FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y \
    curl \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz \
    | tar -xJ -C /usr/local \
    && ln -s /usr/local/zig-linux-x86_64-0.13.0/zig /usr/local/bin/zig

WORKDIR /app
COPY build.zig .
COPY src ./src

RUN zig build -Doptimize=ReleaseSafe

FROM debian:bookworm-slim

WORKDIR /app
COPY --from=builder /app/zig-out/bin/umf-jetzig .

EXPOSE 8006

CMD ["./umf-jetzig"]
