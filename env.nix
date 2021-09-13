{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  paths = with pkgs;
    [ rust-nightly ]
    ++ (lib.optionals (pkgs.stdenv.isAarch64 || !pkgs.stdenv.isDarwin) [
      anchor
      spl-token-cli
    ]) ++ (lib.optionals (!pkgs.stdenv.isAarch64) [ solana ]);
}
