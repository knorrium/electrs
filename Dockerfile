FROM debian:bookworm-slim AS base

ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

RUN apt update -qy
RUN apt install -qy librocksdb-dev

FROM base as build

RUN apt install -qy git clang cmake
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly

WORKDIR /build
COPY . .

RUN cargo +nightly build --release -Z sparse-registry --bin electrs

FROM base as deploy

COPY --from=build /build/target/release/electrs /bin/electrs

EXPOSE 50001

ENTRYPOINT ["/bin/electrs"]