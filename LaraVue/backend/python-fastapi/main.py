from __future__ import annotations

from collections import Counter, defaultdict
from dataclasses import dataclass, asdict
from datetime import datetime, timezone
from hashlib import sha256
from typing import Any, Dict, List, Optional
from uuid import uuid4

from fastapi import FastAPI, Request
from pydantic import BaseModel, Field

app = FastAPI(title="LaraVue Visitor Analytics API", version="1.0.0")


class VisitorEventIn(BaseModel):
    session_id: str
    route: str
    referrer: Optional[str] = None
    user_agent: Optional[str] = None
    ip_address: Optional[str] = None
    consent: bool = False
    dwell_seconds: float = 0.0
    scroll_depth_pct: float = Field(default=0.0, ge=0.0, le=100.0)
    event_type: str = "page_view"
    conversion_name: Optional[str] = None


@dataclass
class VisitorEvent:
    event_id: str
    timestamp_utc: str
    session_id: str
    route: str
    referrer: Optional[str]
    user_agent: Optional[str]
    ip_hash: Optional[str]
    consent: bool
    dwell_seconds: float
    scroll_depth_pct: float
    event_type: str
    conversion_name: Optional[str]
    anomaly_score: float


EVENTS: List[VisitorEvent] = []


def hash_ip(ip_address: Optional[str]) -> Optional[str]:
    if not ip_address:
        return None
    return sha256(ip_address.encode("utf-8")).hexdigest()


def anomaly_score(event: VisitorEventIn) -> float:
    score = 0.0
    if event.dwell_seconds <= 1:
        score += 0.4
    if event.scroll_depth_pct >= 90:
        score += 0.2
    if event.event_type == "conversion":
        score += 0.1
    if not event.consent:
        score += 0.05
    return round(min(score, 1.0), 3)


def rollup() -> Dict[str, Any]:
    route_counts = Counter(e.route for e in EVENTS)
    referrer_counts = Counter(e.referrer or "(direct)" for e in EVENTS)
    session_counts = Counter(e.session_id for e in EVENTS)
    recent = EVENTS[-20:]

    return {
        "total_events": len(EVENTS),
        "unique_sessions": len(session_counts),
        "top_routes": route_counts.most_common(5),
        "top_referrers": referrer_counts.most_common(5),
        "recent_events": [asdict(event) for event in recent],
        "average_dwell_seconds": round(sum(e.dwell_seconds for e in EVENTS) / len(EVENTS), 2) if EVENTS else 0.0,
        "average_scroll_depth_pct": round(sum(e.scroll_depth_pct for e in EVENTS) / len(EVENTS), 2) if EVENTS else 0.0,
    }


@app.get("/health")
def health() -> Dict[str, str]:
    return {"status": "ok"}


@app.post("/events")
async def ingest(event: VisitorEventIn, request: Request) -> Dict[str, Any]:
    ip_address = event.ip_address or (request.client.host if request.client else None)
    record = VisitorEvent(
        event_id=str(uuid4()),
        timestamp_utc=datetime.now(timezone.utc).isoformat(),
        session_id=event.session_id,
        route=event.route,
        referrer=event.referrer,
        user_agent=event.user_agent,
        ip_hash=hash_ip(ip_address),
        consent=event.consent,
        dwell_seconds=event.dwell_seconds,
        scroll_depth_pct=event.scroll_depth_pct,
        event_type=event.event_type,
        conversion_name=event.conversion_name,
        anomaly_score=anomaly_score(event),
    )
    EVENTS.append(record)
    return {"stored": True, "event": asdict(record), "summary": rollup()}


@app.get("/summary")
def summary() -> Dict[str, Any]:
    return rollup()


@app.get("/trends")
def trends(window: int = 10) -> Dict[str, Any]:
    sample = EVENTS[-window:]
    route_counts = Counter(e.route for e in sample)
    referrer_counts = Counter(e.referrer or "(direct)" for e in sample)
    dwell_by_route: Dict[str, List[float]] = defaultdict(list)

    for event in sample:
        dwell_by_route[event.route].append(event.dwell_seconds)

    avg_dwell_by_route = {
        route: round(sum(values) / len(values), 2)
        for route, values in dwell_by_route.items()
    }

    return {
        "window": window,
        "event_count": len(sample),
        "route_counts": route_counts.most_common(),
        "referrer_counts": referrer_counts.most_common(),
        "avg_dwell_by_route": avg_dwell_by_route,
    }
