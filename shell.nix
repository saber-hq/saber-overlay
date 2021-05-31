{ pkgs }:

let bpfSDK = pkgs.stableswap.solana-bpf-sdk;
in pkgs.mkShell rec {
  buildInputs = [ (import ./env.nix { inherit pkgs; }) ];

  # Use the SDK's version of llvm to build the compiler-builtins for BPF
  CC = "${bpfSDK}/dependencies/bpf-tools/llvm/bin/clang";
  AR = "${bpfSDK}/dependencies/bpf-tools/llvm/bin/llvm-ar";
  OBJDUMP = "${bpfSDK}/dependencies/bpf-tools/llvm/bin/llvm-objdump";
  OBJCOPY = "${bpfSDK}/dependencies/bpf-tools/llvm/bin/llvm-objcopy";

  # Use the SDK's version of Rust to build for BPF
  RUSTUP_TOOLCHAIN = "bpf";
  RUSTFLAGS = "-C lto=no -C opt-level=2 -C link-arg=-z"
    + " -C link-arg=notext -C link-arg=-T${bpfSDK}/rust/bpf.ld"
    + " -C link-arg=--Bdynamic -C link-arg=-shared"
    + " -C link-arg=--threads=1 -C link-arg=--entry=entrypoint"
    + " -C linker=${bpfSDK}/dependencies/bpf-tools/llvm/bin/ld.lld";

  shellHook = ''
    export CC=${CC}
    export AR=${AR}
    export OBJDUMP=${OBJDUMP}
    export OBJCOPY=${OBJCOPY}

    rustup toolchain uninstall bpf
    rustup toolchain link bpf ${pkgs.stableswap.solana-bpf-tools}/rust
  '';
}
