# based on https://github.com/orhun/rustypaste/blob/8329095c7585142a4f9e36e1ab74bbcbbeae73d9/Dockerfile


FROM rust:alpine AS builder

WORKDIR /app
RUN apk update
RUN apk add --no-cache musl-dev
COPY Cargo.toml .
RUN mkdir -p src/
RUN echo "fn main() { println!(\"failed to build\") }" > src/main.rs
RUN cargo build --release
RUN rm -f target/release/deps/cloudflare-speed-cli*
COPY . .
RUN cargo build --locked --release


FROM scratch

COPY --from=builder /app/target/release/cloudflare-speed-cli /bin/
WORKDIR /app
USER 1000:1000
ENTRYPOINT ["cloudflare-speed-cli"]
