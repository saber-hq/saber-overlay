{ pkgs }:
with pkgs;
buildEnv {
  name = "ci";
  paths = (lib.optionals stdenv.isLinux ([ libudev ])) ++ [
    solana-install
    anchor-0_19_0
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
