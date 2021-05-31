{ pkgs, rustPlatform }: rec {
  solana-bpf-tools = pkgs.callPackage ./solana-bpf-tools.nix {
    inherit (pkgs) autoPatchelfHook stdenv openssl zlib fetchurl;
  };

  solana-bpf-sdk = pkgs.callPackage ./solana-bpf-sdk.nix {
    inherit solana-bpf-tools;
    inherit (pkgs) fetchFromGitHub stdenv;
  };

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
}
