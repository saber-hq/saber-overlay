{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = (with pkgs; [ rustup spl-token-cli saber-devenv ]);
}
