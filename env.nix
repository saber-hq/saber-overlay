{ pkgs }:
let
  solanaPkgs = with pkgs;
    if stdenv.hostPlatform.isDarwin then
      [ solana.solana-full ]
    else
      [ solana.solana-full ];
in pkgs.buildEnv {
  name = "saber-env";
  paths = solanaPkgs
    ++ (with pkgs; [ anchor rust-nightly spl-token-cli cargo-workspaces ]);
}
