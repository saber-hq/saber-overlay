{ pkgs }:

pkgs.mkShell {
  buildInputs = [ (import ./env.nix { inherit pkgs; }) ];
  shellHook = ''
    rustup toolchain uninstall bpf
    rustup toolchain link bpf ${pkgs.stableswap.solana-bpf-tools}
  '';
}
