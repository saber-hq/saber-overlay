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
  mkSolanaPackage = name: cargoSha256:
    mkSolana {
      inherit name cargoSha256;
      solanaPkgs = [ name ];
    };
in anchorPackages // {
  # This is the ideal package to use
  solana-full = mkSolana {
    cargoSha256 = "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU=";
  };

  solana-cli = mkSolana {
    name = "solana-cli";
    solanaPkgs = [ "solana" ];
    cargoSha256 = "sha256-GoLalVtKTi8Szqgc+Z8X4pYHNBGosVDDjb+QpmEwnEA=";
  };
  solana-keygen = mkSolanaPackage "solana-keygen"
    "sha256-eli0HuDOrDD+8rxJXduv30OWTE4uGCb6pScFPNob2TY=";
  solana-install = mkSolanaPackage "solana-install"
    "sha256-4K9BffQvZzLf4p7hhXZj7nGbXKqX8CpWoRSvAFcshTs=";
  solana-install-init = mkSolanaPackage "solana-install-init"
    "sha256-TSGU7ZUQdRwKWS+X7eW6iHYSrf+QJQZ6KyLDWdG1oEw=";

  cargo-build-bpf = mkSolanaPackage "cargo-build-bpf"
    "sha256-y2juHbVx36BlyJNjEieNyFKKIJ6d1yCr/J+j3vbqtJ4=";
  cargo-test-bpf = mkSolanaPackage "cargo-test-bpf"
    "sha256-nSfta+vK8pkRMoW4/XKPPB3hCmu0/xg23zW4xEKX6JA=";

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
