FROM rust:1.82-slim-bookworm AS base

ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN apt update -qy && \
    apt install -qy librocksdb-dev curl

FROM base as build

RUN apt install -qy git clang cmake

WORKDIR /build

COPY . .

RUN cargo build --release --bin electrs

FROM base as deploy

COPY --from=build /build/target/release/electrs /bin/electrs

EXPOSE 50001

ENTRYPOINT ["/bin/electrs"]