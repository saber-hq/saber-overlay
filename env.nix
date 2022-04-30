{ pkgs }:
with pkgs;
buildEnv {
  name = "saber-env";
  paths = [ spl-token-cli saber-devenv move-cli-address32 ];
}
