{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs;
    ([ anchor rust-nightly spl-token-cli ]
      ++ (if pkgs.stdenv.isDarwin then [ solana-cli ] else [ solana-full ]));
}
