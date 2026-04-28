use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::HashMap;
use std::sync::Mutex;
use uuid::Uuid;

#[derive(Clone, Serialize, Deserialize)]
struct VisitorEventIn {
    session_id: String,
    route: String,
    referrer: Option<String>,
    user_agent: Option<String>,
    ip_address: Option<String>,
    consent: bool,
    dwell_seconds: f64,
    scroll_depth_pct: f64,
    event_type: String,
    conversion_name: Option<String>,
}

#[derive(Clone, Serialize, Deserialize)]
struct VisitorEvent {
    event_id: String,
    timestamp_utc: String,
    session_id: String,
    route: String,
    referrer: Option<String>,
    user_agent: Option<String>,
    ip_hash: Option<String>,
    consent: bool,
    dwell_seconds: f64,
    scroll_depth_pct: f64,
    event_type: String,
    conversion_name: Option<String>,
    anomaly_score: f64,
}

struct AppState {
    events: Mutex<Vec<VisitorEvent>>,
}

fn hash_ip(value: Option<String>) -> Option<String> {
    value.map(|v| {
        let mut hasher = Sha256::new();
        hasher.update(v.as_bytes());
        format!("{:x}", hasher.finalize())
    })
}

fn anomaly_score(payload: &VisitorEventIn) -> f64 {
    let mut score = 0.0;
    if payload.dwell_seconds <= 1.0 { score += 0.4; }
    if payload.scroll_depth_pct >= 90.0 { score += 0.2; }
    if payload.event_type == "conversion" { score += 0.1; }
    if !payload.consent { score += 0.05; }
    score.min(1.0)
}

#[get("/health")]
async fn health() -> impl Responder {
    HttpResponse::Ok().json(serde_json::json!({ "status": "ok" }))
}

#[post("/events")]
async fn ingest(state: web::Data<AppState>, payload: web::Json<VisitorEventIn>) -> impl Responder {
    let record = VisitorEvent {
        event_id: Uuid::new_v4().to_string(),
        timestamp_utc: chrono::Utc::now().to_rfc3339(),
        session_id: payload.session_id.clone(),
        route: payload.route.clone(),
        referrer: payload.referrer.clone(),
        user_agent: payload.user_agent.clone(),
        ip_hash: hash_ip(payload.ip_address.clone()),
        consent: payload.consent,
        dwell_seconds: payload.dwell_seconds,
        scroll_depth_pct: payload.scroll_depth_pct,
        event_type: payload.event_type.clone(),
        conversion_name: payload.conversion_name.clone(),
        anomaly_score: anomaly_score(&payload),
    };

    let mut events = state.events.lock().unwrap();
    events.push(record.clone());

    HttpResponse::Ok().json(serde_json::json!({
        "stored": true,
        "event": record,
        "total_events": events.len()
    }))
}

#[get("/summary")]
async fn summary(state: web::Data<AppState>) -> impl Responder {
    let events = state.events.lock().unwrap();
    let mut route_counts: HashMap<String, usize> = HashMap::new();
    let mut referrer_counts: HashMap<String, usize> = HashMap::new();

    for event in events.iter() {
        *route_counts.entry(event.route.clone()).or_insert(0) += 1;
        let key = event.referrer.clone().unwrap_or_else(|| "(direct)".to_string());
        *referrer_counts.entry(key).or_insert(0) += 1;
    }

    HttpResponse::Ok().json(serde_json::json!({
        "total_events": events.len(),
        "top_routes": route_counts,
        "top_referrers": referrer_counts
    }))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let state = web::Data::new(AppState { events: Mutex::new(Vec::new()) });

    HttpServer::new(move || {
        App::new()
            .app_data(state.clone())
            .service(health)
            .service(ingest)
            .service(summary)
    })
    .bind(("0.0.0.0", 8080))?
    .run()
    .await
}
