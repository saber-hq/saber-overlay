{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs; [ solana spl-token-cli saber.rustNightly.rust ];
}
