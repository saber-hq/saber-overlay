{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs;
    ([ anchor rust-nightly spl-token-cli ]
      ++ (lib.optionals (!pkgs.stdenv.isAarch64) [ solana ]));
}
