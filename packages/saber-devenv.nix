{ pkgs, anchor, solana-basic, saber-dev-utilities, saber-rust-build-common }:
with pkgs;
buildEnv {
  name = "saber-devenv";
  paths = [
    solana-basic
    anchor

    saber-dev-utilities
    saber-rust-build-common

    # NodeJS stuff
    nodejs
    yarn
    python3
  ];
}
