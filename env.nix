{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs;
    [ spl-token-cli rust-nightly anchor ]
    ++ (lib.optionals (!pkgs.stdenv.isAarch64) [ solana ]);
}
