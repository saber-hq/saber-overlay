{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs; [ solana spl-token-cli anchor saber.rustNightly.rust ];
}
