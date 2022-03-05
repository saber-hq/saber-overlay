{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = (with pkgs; [ rust-nightly spl-token-cli saber-devenv ]);
}
