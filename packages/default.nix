{ pkgs, rustNightly, rustStable, rustfmt }:
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
    inherit (rustStable) rustPlatform;
    inherit (pkgs)
      lib pkgconfig libudev openssl zlib fetchFromGitHub stdenv protobuf;
    inherit (pkgs.llvmPackages_12) clang llvm libclang;
    inherit darwinPackages;
    inherit rustfmt;
  };

  anchor = pkgs.callPackage ./anchor {
    inherit (rustNightly) rustPlatform;
    inherit pkgs;
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
