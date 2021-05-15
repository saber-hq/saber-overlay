{ pkgs ? import <nixpkgs> { overlays = [ (import ./default.nix) ]; } }:
pkgs.buildEnv {
  name = "stableswap-env";
  paths = with pkgs.stableswap; [ solana anchor rustc cargo ];
}
