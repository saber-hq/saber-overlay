{ pkgs, rustNightly, rustStable }:
let
  darwinPackages = pkgs.lib.optionals pkgs.stdenv.isDarwin
    (with pkgs.darwin.apple_sdk.frameworks;
      ([ IOKit Security CoreFoundation AppKit ]
        ++ (pkgs.lib.optionals pkgs.stdenv.isAarch64 [ System ])));
  anchorPackages = import ./anchor {
    inherit (rustStable) rustPlatform;
    inherit (pkgs) lib pkgconfig openssl stdenv udev fetchFromGitHub;
    inherit darwinPackages;
  };
  solanaPackages =
    (import ./solana { inherit pkgs rustStable darwinPackages; });
in anchorPackages // solanaPackages // rec {
  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit (rustStable) rustPlatform;
    inherit (pkgs) lib clang llvm pkgconfig openssl zlib udev stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit darwinPackages;
  };

  cargo-workspaces = pkgs.callPackage ./cargo-workspaces.nix {
    inherit (rustStable) rustPlatform;
    inherit (pkgs) lib pkgconfig openssl zlib stdenv fetchCrate libssh2;
    libgit2 = pkgs.libgit2_1_3_0;
    inherit darwinPackages;
  };

  rust-nightly = rustNightly.rust;
  rust-stable = rustStable.rust;
  saber-devenv = import ./saber-devenv.nix {
    inherit pkgs;
    inherit (anchorPackages) anchor;
    inherit (solanaPackages.solana) solana-basic;
    inherit cargo-workspaces;
  };

  saber-rust-build-common = with pkgs;
    buildEnv {
      paths = [ pkgconfig openssl zlib libiconv ]
        ++ (lib.optionals stdenv.isLinux ([ udev ]))
        ++ (lib.optionals stdenv.isDarwin
          (with darwin.apple_sdk.frameworks; [ AppKit IOKit Foundation ]));
    };
}
