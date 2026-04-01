FROM rust:slim AS builder

WORKDIR /app

COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/target/release/cfg-parser /usr/local/bin/cfgparser

ENTRYPOINT ["/usr/local/bin/cfgparser"]
