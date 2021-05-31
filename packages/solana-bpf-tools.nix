{ fetchurl, autoPatchelfHook, stdenv, openssl, zlib }:
let
  version = "1.5";
  src = fetchurl {
    name = "solana-bpf-tools-linux";
    url =
      "https://github.com/solana-labs/bpf-tools/releases/download/v${version}/solana-bpf-tools-linux.tar.bz2";
    sha256 = "sha256-UdqjoGh0kOaZdUNsUWqk64QE21VeC7GY30wjIalHq9U=";
  };

  solana-bpf-tools-rustbin = stdenv.mkDerivation rec {
    inherit src version;
    name = "solana-bpf-tools-rustbin";

    nativeBuildInputs = [ autoPatchelfHook stdenv.cc.cc.lib ];
    buildInputs = [ openssl zlib ];

    unpackPhase = ''
      tar xjvf ${src}
    '';

    installPhase = ''
      mkdir -p $out/lib
      mv rust/bin/ $out/bin/
      mv rust/lib/*.so $out/lib/
    '';
  };

  solana-bpf-tools-rust = stdenv.mkDerivation rec {
    inherit src version;
    name = "solana-bpf-tools-rust";

    buildInputs = [ solana-bpf-tools-rustbin ];

    unpackPhase = ''
      tar xjvf ${src}
    '';

    installPhase = ''
      mkdir -p $out/lib
      mv rust/lib/rustlib/ $out/lib/rustlib
      cp -R ${solana-bpf-tools-rustbin}/bin $out/bin
      cp -R ${solana-bpf-tools-rustbin}/lib/*.so $out/lib/
    '';
  };

  solana-bpf-tools-llvm = stdenv.mkDerivation rec {
    inherit src version;
    name = "solana-bpf-tools-llvm";

    nativeBuildInputs = [ autoPatchelfHook stdenv.cc.cc.lib ];
    buildInputs = [ openssl zlib ];

    unpackPhase = ''
      tar xjvf ${src}
    '';

    installPhase = ''
      mkdir -p $out
      mv llvm/bin/ $out/bin/
      mv llvm/lib/ $out/lib/
    '';
  };
in stdenv.mkDerivation {
  inherit version;
  name = "solana-bpf-sdk";

  buildInputs = [ solana-bpf-tools-rust solana-bpf-tools-llvm ];

  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out

    ln -s ${solana-bpf-tools-rust} $out/rust
    ln -s ${solana-bpf-tools-llvm} $out/llvm
  '';
}
