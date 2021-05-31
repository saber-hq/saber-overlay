{ pkgs, rustPlatform }: {
  solana = pkgs.callPackage ./solana.nix {
    inherit rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib fetchFromGitHub stdenv;
    inherit (pkgs.llvmPackages) libclang;
    inherit (pkgs.darwin.apple_sdk.frameworks)
      IOKit Security CoreFoundation AppKit;
  };

  anchor = pkgs.callPackage ./anchor.nix {
    inherit rustPlatform pkgs;
    inherit (pkgs.darwin.apple_sdk.frameworks)
      IOKit Security CoreFoundation AppKit;
  };

  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit (pkgs.darwin.apple_sdk.frameworks)
      IOKit Security CoreFoundation AppKit;
  };

  solana-bpf-tools = with pkgs;
    stdenv.mkDerivation rec {
      name = "solana-bpf-tools";
      version = "1.5";

      src = fetchurl {
        name = "solana-bpf-tools-linux";
        url =
          "https://github.com/solana-labs/bpf-tools/releases/download/v${version}/solana-bpf-tools-linux.tar.bz2";
        sha256 = "sha256-UdqjoGh0kOaZdUNsUWqk64QE21VeC7GY30wjIalHq9U=";
      };
      nativeBuildInputs = [ autoPatchelfHook stdenv.cc.cc.lib ];
      buildInputs = [ openssl zlib ];

      unpackPhase = ''
        tar xjvf ${src}
      '';

      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib

        mv rust/bin/* $out/bin/
        mv rust/lib/* $out/lib/

        mv llvm/bin/* $out/bin/
        mv llvm/lib/* $out/lib/
      '';
    };
}
