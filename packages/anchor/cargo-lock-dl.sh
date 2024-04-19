#!/usr/bin/env bash -xe

VERSIONS=(
    "0.12.0"
    "0.13.2"
    "0.15.0"
    "0.16.1"
    "0.17.0"
    "0.18.0"
    "0.18.2"
    "0.19.0"
    "0.20.0"
    "0.20.1"
    "0.21.0"
    "0.22.0"
    "0.23.0"
    "0.24.0"
    "0.24.2"
    "0.25.0"
    "0.26.0"
    "0.27.0"
    "0.28.0"
    "0.29.0"
    "0.30.0"
)

for VERSION in "${VERSIONS[@]}"; do
    echo "Downloading Cargo.lock@$VERSION"
    mkdir -p cargo/v$VERSION
    curl https://raw.githubusercontent.com/coral-xyz/anchor/v$VERSION/Cargo.lock >cargo/v$VERSION/Cargo.lock

    PATCH_FILE=./patches/cargo-$VERSION.patch
    if [ -f $PATCH_FILE ]; then
        echo "We have a patch for $VERSION. Patching"
        patch --reject-file=/dev/null --no-backup-if-mismatch -f ./cargo/v$VERSION/Cargo.lock <$PATCH_FILE || {
            echo "Patched."
        }
    fi
done
