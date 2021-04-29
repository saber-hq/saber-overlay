let pkgs = import <nixpkgs> { overlays = [ (import ./default.nix) ]; };
in with pkgs;
mkShell {
  nativeBuildInputs =
    [ solana-rust-bpf solana xargo cargo-deps cargo-watch rustfmt clippy ];
  RUST_BACKTRACE = "1";
  XARGO_RUST_SRC = "${rust-bpf-sysroot}/src";
  RUST_COMPILER_RT_ROOT = "${rust-bpf-sysroot}/src/compiler-rt";

  SOLANA_LLVM_CC = "${solana-llvm}/bin/clang"; # CC gets overwritten
  SOLANA_LLVM_AR = "${solana-llvm}/bin/llvm-ar"; # AR gets overwritten

  CARGO_TARGET_DIR = "target-bpf";

  # Get bpf.ld from npm?
  RUSTFLAGS =
    "-C lto=no -C opt-level=2 -C link-arg=-z -C link-arg=notext -C link-arg=-T${rust-bpf-sysroot}/bpf.ld -C link-arg=--Bdynamic -C link-arg=-shared -C link-arg=--entry=entrypoint -C link-arg=-no-threads -C linker=${solana-llvm}/bin/ld.lld";
}
