FROM rust:1.88-slim-bookworm AS builder

RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Cargo.toml ./
RUN mkdir src && echo 'fn main(){}' > src/main.rs
RUN cargo build --release --locked
RUN rm -f target/release/deps/umf_actix*

COPY src ./src
RUN cargo build --release --locked

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    libpq5 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/target/release/umf-actix .

ENV PORT=8002
EXPOSE 8002

CMD ["./umf-actix"]
