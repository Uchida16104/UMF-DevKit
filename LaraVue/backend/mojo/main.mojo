# LaraVue Mojo sample
# This file illustrates the same visitor analytics contract in a compact form.

struct VisitorEvent:
    var route: String
    var referrer: String
    var dwell_seconds: Float64
    var consent: Bool

fn anomaly_score(event: VisitorEvent) -> Float64:
    var score: Float64 = 0.0
    if event.dwell_seconds <= 1.0:
        score += 0.4
    if event.route == "/pricing":
        score += 0.1
    if not event.consent:
        score += 0.05
    if score > 1.0:
        return 1.0
    return score

fn main():
    let events = [
        VisitorEvent(route: "/", referrer: "(direct)", dwell_seconds: 12.0, consent: True),
        VisitorEvent(route: "/docs", referrer: "https://example.com/", dwell_seconds: 41.0, consent: True),
        VisitorEvent(route: "/pricing", referrer: "(direct)", dwell_seconds: 3.0, consent: False),
    ]

    var total: Float64 = 0.0
    for event in events:
        total += event.dwell_seconds

    print("total_events=", events.len)
    print("average_dwell_seconds=", total / Float64(events.len))
    print("first_anomaly_score=", anomaly_score(events[0]))
