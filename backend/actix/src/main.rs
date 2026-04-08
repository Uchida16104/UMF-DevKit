use actix_cors::Cors;
use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use serde::{Deserialize, Serialize};
use std::env;

#[derive(Serialize)]
struct HealthResponse {
    status: &'static str,
    service: &'static str,
    version: &'static str,
}

#[derive(Serialize)]
struct HelloResponse {
    message: String,
    framework: &'static str,
    language: &'static str,
}

#[derive(Deserialize)]
struct GreetRequest {
    name: String,
}

#[derive(Serialize)]
struct GreetResponse {
    greeting: String,
}

#[get("/")]
async fn index() -> impl Responder {
    HttpResponse::Ok().json(HelloResponse {
        message: "UMF-DevKit Actix-web service is running.".to_string(),
        framework: "Actix-web",
        language: "Rust",
    })
}

#[get("/health")]
async fn health() -> impl Responder {
    HttpResponse::Ok().json(HealthResponse {
        status: "ok",
        service: "umf-actix",
        version: env!("CARGO_PKG_VERSION"),
    })
}

#[get("/hello")]
async fn hello() -> impl Responder {
    HttpResponse::Ok().json(HelloResponse {
        message: "Hello from Actix-web!".to_string(),
        framework: "Actix-web",
        language: "Rust",
    })
}

#[post("/greet")]
async fn greet(body: web::Json<GreetRequest>) -> impl Responder {
    HttpResponse::Ok().json(GreetResponse {
        greeting: format!("Hello, {}! — from Actix-web (Rust)", body.name),
    })
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(env_logger::Env::default().default_filter_or("info"));

    let port: u16 = env::var("PORT")
        .unwrap_or_else(|_| "8002".to_string())
        .parse()
        .expect("PORT must be a valid number");

    log::info!("Starting Actix-web server on port {}", port);

    HttpServer::new(|| {
        let cors = Cors::default()
            .allow_any_origin()
            .allow_any_method()
            .allow_any_header()
            .max_age(3600);

        App::new()
            .wrap(cors)
            .service(index)
            .service(health)
            .service(hello)
            .service(greet)
    })
    .bind(("0.0.0.0", port))?
    .run()
    .await
}
