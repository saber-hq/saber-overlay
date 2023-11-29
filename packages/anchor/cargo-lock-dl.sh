#!/usr/bin/env bash

VERSIONS=(
    "0.16.1"
    "0.17.0"
    "0.18.0"
    "0.18.2"
    "0.19.0"
    "0.20.0"
    "0.21.0"
    "0.22.0"
    "0.23.0"
    "0.24.0"
    "0.24.2"
)

for VERSION in "${VERSIONS[@]}"; do
    echo "Downloading Cargo.lock@$VERSION"
    curl https://raw.githubusercontent.com/coral-xyz/anchor/v$VERSION/Cargo.lock >cargo/v$VERSION.Cargo.lock
done
