{ pkgs }:
pkgs.buildEnv {
  name = "saber-env";
  # paths = with pkgs; [ anchor ];
  paths = with pkgs;
    [ spl-token-cli saber.rustNightly.rust anchor ]
    ++ (lib.optionals (!pkgs.stdenv.isAarch64) [ solana ]);
}
