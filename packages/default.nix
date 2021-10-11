{ pkgs, rustNightly, rustStable }:
let
  darwinPackages = pkgs.lib.optionals pkgs.stdenv.isDarwin
    (with pkgs.darwin.apple_sdk.frameworks;
      ([ IOKit Security CoreFoundation AppKit ]
        ++ (pkgs.lib.optionals pkgs.stdenv.isAarch64 [ System ])));
  anchorPackages = import ./anchor {
    inherit (rustNightly) rustPlatform;
    inherit (pkgs) lib pkgconfig openssl libudev stdenv fetchFromGitHub;
    inherit darwinPackages;
  };
  mkSolana = args:
    (pkgs.callPackage ./solana.nix ({
      inherit (rustStable) rustPlatform;
      inherit (pkgs)
        lib pkgconfig libudev openssl zlib fetchFromGitHub stdenv protobuf
        rustfmt;
      inherit (pkgs.llvmPackages_12) clang llvm libclang;
      inherit darwinPackages;
    } // args));
  mkSolanaPackage = name:
    mkSolana {
      inherit name;
      solanaPkgs = [ name ];
    };
in anchorPackages // {
  solana-full = mkSolana { };
  solana-cli = mkSolana {
    name = "solana-cli";
    solanaPkgs = [ "solana" ];
    cargoSha256 = "sha256-GoLalVtKTi8Szqgc+Z8X4pYHNBGosVDDjb+QpmEwnEA=";
  };
  solana-keygen = mkSolanaPackage "solana-keygen";
  solana-test-validator = mkSolanaPackage "solana-test-validator";

  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit (rustNightly) rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit darwinPackages;
  };

  rust-nightly = rustNightly.rust;
  rust-stable = rustStable.rust;
}
