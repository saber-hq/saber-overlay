name: Build
on:
  push:
    branches:
      - master
jobs:
  tests:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: cachix/install-nix-action@v12
    - run: nix-build shell.nix -A nativeBuildInputs
