{ pkgs, rustNightly, rustStable }:
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
  anchorPackages = import ./anchor {
    inherit (rustNightly) rustPlatform;
    inherit (pkgs) lib pkgconfig openssl libudev stdenv fetchFromGitHub;
    inherit darwinPackages;
  };
in anchorPackages // {
  solana = pkgs.callPackage ./solana.nix {
    inherit (rustStable) rustPlatform;
    inherit (pkgs)
      lib pkgconfig libudev openssl zlib fetchFromGitHub stdenv protobuf
      rustfmt;
    inherit (pkgs.llvmPackages_12) clang llvm libclang;
    inherit darwinPackages;
  };

  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit (rustNightly) rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit darwinPackages;
  };
}
