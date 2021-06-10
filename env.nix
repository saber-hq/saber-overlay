{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs.saber; [
    solana
    # TODO(igm): add anchor back in once it no longer uses a git dep
    # anchor 
    rust
    spl-token-cli
  ];
}
