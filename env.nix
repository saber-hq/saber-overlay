{ pkgs }:
with pkgs;
buildEnv {
  name = "saber-env";
  paths = [ spl-token-cli saber-devenv ];
}
