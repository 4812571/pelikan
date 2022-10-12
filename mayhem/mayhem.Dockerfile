# Build Stage
FROM ubuntu:20.04 as builder

# Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl

# Install Rust.
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install -f cargo-fuzz

## Add the source code.
ADD . /pelikan
WORKDIR /pelikan

# Compile the fuzzers.
RUN ${HOME}/.cargo/bin/cargo fuzz build --fuzz-dir /pelikan/src/storage/seg/fuzz