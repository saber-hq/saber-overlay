{ pkgs }:
pkgs.buildEnv {
  name = "stableswap-env";
  paths = with pkgs.stableswap; [
    solana
    # TODO(igm): add anchor back in once it no longer uses a git dep
    # anchor 
    rust
    spl-token-cli
  ];
}
