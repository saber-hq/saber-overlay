{ pkgs, solana-bpf-tools, solana-full, ... }:
let
  wrapped = pkgs.writeShellScriptBin "cargo-build-bpf-2" ''
    ${solana-full}/bin/cargo-build-bpf $@
  '';

in pkgs.symlinkJoin {
  name = "hello";
  paths = [ solana-bpf-tools solana-full wrapped ];
}
