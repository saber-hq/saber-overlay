{ pkgs, rustPlatform }: {
  solana = pkgs.callPackage ./solana.nix {
    inherit rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib fetchFromGitHub stdenv;
    inherit (pkgs.llvmPackages) libclang;
    inherit (pkgs.darwin.apple_sdk_11_0.frameworks)
      IOKit Security CoreFoundation AppKit System;
  };

  anchor = pkgs.callPackage ./anchor.nix {
    inherit rustPlatform pkgs;
    inherit (pkgs.darwin.apple_sdk_11_0.frameworks)
      IOKit Security CoreFoundation AppKit System;
  };

  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit (pkgs.darwin.apple_sdk_11_0.frameworks)
      IOKit Security CoreFoundation AppKit System;
  };
}
