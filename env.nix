{ pkgs }:
let
  solanaPkgs = with pkgs;
    if stdenv.hostPlatform.isDarwin then [
      solana-cli
      solana-keygen
      solana-install
      solana-install-init

      cargo-build-bpf
      cargo-test-bpf
    ] else
      [ solana-full ];
in pkgs.buildEnv {
  name = "saber-env";
  paths = solanaPkgs
    ++ (with pkgs; [ anchor rust-nightly spl-token-cli cargo-workspaces ]);
}
