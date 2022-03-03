{ pkgs, anchor, solana-basic, cargo-workspaces, solana-full, ... }:
with pkgs;
buildEnv {
  name = "saber-devenv";
  paths = (lib.optionals stdenv.isLinux ([ udev solana-full ])) ++ [
    # solana-basic
    anchor

    cargo-workspaces
    cargo-expand
    cargo-deps
    cargo-readme

    # sdk
    nodejs
    yarn
    python3

    pkgconfig
    openssl
    jq
    gnused

    libiconv
  ] ++ (lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ AppKit IOKit Foundation ]));
}
