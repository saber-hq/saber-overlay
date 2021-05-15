{ pkgs ? import <nixpkgs> { overlays = [ (import ./default.nix) ]; } }:
with pkgs;
buildEnv {
  name = "stableswap-env";
  paths = [ solana ];
}
