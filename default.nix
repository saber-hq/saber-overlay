_: pkgs: {
  stableswap = rec {
    rust = pkgs.rust-bin.stable.latest.default;
    rustPlatform = pkgs.recurseIntoAttrs (pkgs.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });

    solana = pkgs.callPackage ./packages/solana.nix {
      inherit rustPlatform;
      inherit (pkgs)
        lib clang llvm pkgconfig libudev openssl zlib fetchFromGitHub stdenv;
      inherit (pkgs.llvmPackages) libclang;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        IOKit Security CoreFoundation AppKit;
    };

    anchor = pkgs.callPackage ./packages/anchor.nix {
      inherit rustPlatform pkgs;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        IOKit Security CoreFoundation AppKit;
    };

    spl-token-cli = pkgs.callPackage ./packages/spl-token-cli.nix {
      inherit rustPlatform;
      inherit (pkgs)
        lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
      inherit (pkgs.llvmPackages) libclang;
      inherit (pkgs.darwin.apple_sdk.frameworks)
        IOKit Security CoreFoundation AppKit;
    };
  };
}
