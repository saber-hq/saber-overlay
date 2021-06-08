{ pkgs, rustPlatform }:
let
  darwinPackages =
    pkgs.lib.optionals (pkgs.stdenv.isDarwin && pkgs.stdenv.isAarch64)
    (with pkgs.darwin.apple_sdk.frameworks; [
      IOKit
      Security
      CoreFoundation
      AppKit
      System
    ]);
in {
  solana = pkgs.callPackage ./solana.nix {
    inherit rustPlatform;
    inherit (pkgs)
      lib pkgconfig libudev openssl zlib fetchFromGitHub stdenv;
    inherit (pkgs.llvmPackages_12) clang llvm libclang;
    inherit darwinPackages;
  };

  anchor = pkgs.callPackage ./anchor.nix {
    inherit rustPlatform pkgs;
    inherit darwinPackages;
  };

  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit darwinPackages;
  };
}
