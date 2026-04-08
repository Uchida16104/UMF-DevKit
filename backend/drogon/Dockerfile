FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    libjsoncpp-dev \
    libpq-dev \
    uuid-dev \
    zlib1g-dev \
    libc-ares-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/drogonframework/drogon.git /drogon \
    && cd /drogon \
    && git submodule update --init \
    && mkdir build && cd build \
    && cmake .. -DBUILD_EXAMPLES=OFF -DBUILD_CTL=OFF \
    && make -j$(nproc) \
    && make install

WORKDIR /app
COPY CMakeLists.txt main.cc ./

RUN mkdir build && cd build \
    && cmake .. \
    && make -j$(nproc)

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libssl3 \
    libjsoncpp25 \
    libc-ares2 \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/build/umf_drogon .

EXPOSE 8005

CMD ["./umf_drogon"]
