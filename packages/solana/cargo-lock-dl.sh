#!/usr/bin/env bash -xe

VERSIONS=(
    "1.8.16"
    "1.9.28"
    "1.10.39"
    "1.11.10"
    "1.13.5"
    "1.17.6"
    "1.18.11"
    "1.18.23"
)

for VERSION in "${VERSIONS[@]}"; do
    echo "Downloading Cargo.lock@$VERSION"
    mkdir -p cargo/v$VERSION
    curl https://raw.githubusercontent.com/solana-labs/solana/v$VERSION/Cargo.lock >cargo/v$VERSION/Cargo.lock
done
