{ pkgs }:
pkgs.buildEnv {
  name = "stableswap-env";
  paths = with pkgs.stableswap; [ solana anchor rust ];
}
