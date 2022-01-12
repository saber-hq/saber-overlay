{ pkgs }:
with pkgs;
buildEnv {
  name = "saber-ci";
  paths = (lib.optionals stdenv.isLinux ([ libudev ])) ++ [
    solana.solana-basic
    anchor-0_20_1
    cargo-workspaces

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
