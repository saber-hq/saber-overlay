{ pkgs
, rustNightly
, rustStable
, rust-1_60
}:
let
  darwinPackages = pkgs.lib.optionals pkgs.stdenv.isDarwin
    (with pkgs.darwin.apple_sdk.frameworks;
    ([ IOKit Security CoreFoundation AppKit ]
      ++ (pkgs.lib.optionals pkgs.stdenv.isAarch64 [ System ])));
  anchorPackages = import ./anchor {
    inherit rustStable;
    inherit (pkgs) lib pkg-config openssl stdenv udev fetchFromGitHub;
    inherit darwinPackages;
  };
  solanaPackages =
    (import ./solana { inherit pkgs rustStable darwinPackages rust-1_60; });

  solanaFlattened = with solanaPackages; {
    solana-1_8-basic = solana-1_8.solana-basic;
    solana-1_8-full = solana-1_8.solana-full;

    solana-1_9-basic = solana-1_9.solana-basic;
    solana-1_9-full = solana-1_9.solana-full;

    solana-1_10-basic = solana-1_10.solana-basic;
    solana-1_10-full = solana-1_10.solana-full;

    solana-1_11-basic = solana-1_11.solana-basic;
    solana-1_11-full = solana-1_11.solana-full;

    solana-1_13-basic = solana-1_13.solana-basic;
    solana-1_13-full = solana-1_13.solana-full;

    solana-1_17-basic = solana-1_17.solana-basic;
    solana-1_17-full = solana-1_17.solana-full;

    solana-basic = solana.solana-basic;
    solana-full = solana.solana-full;
  };
in
anchorPackages // solanaFlattened // rec {
  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit (rustStable) rustPlatform;
    inherit (pkgs) lib clang llvm pkg-config openssl zlib udev stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit darwinPackages;
  };

  rust-nightly = rustNightly.rust;
  rust-stable = rustStable.rust;

  saber-dev-utilities = with pkgs;
    buildEnv {
      name = "saber-dev-utilities";
      meta.description = "Various CLI tools commonly used in development.";

      paths = [
        cargo-workspaces
        cargo-expand
        cargo-deps
        cargo-readme

        curl
        gh
        gnused
        jq
        nixfmt
        rustup
        yj
      ];
    };

  saber-devenv = import ./saber-devenv.nix {
    inherit pkgs;
    inherit (anchorPackages) anchor;
    inherit (solanaPackages.solana) solana-basic;
    inherit saber-dev-utilities saber-rust-build-common;
  };

  saber-rust-build-common = with pkgs;
    buildEnv {
      name = "saber-rust-build-common";
      meta.description = "Common utilities for building Rust packages.";

      paths = [ pkg-config openssl zlib libiconv ]
      ++ (lib.optionals stdenv.isLinux ([ udev ]))
      ++ (lib.optionals stdenv.isDarwin
        (with darwin.apple_sdk.frameworks; [ AppKit IOKit Foundation ]));
    };
}
