{ pkgs }:
pkgs.buildEnv {
  name = "stableswap-env";
  paths = with pkgs.stableswap; [
    solana
    anchor
    spl-token-cli
    pkgs.python39
    pkgs.criterion
  ];
}
