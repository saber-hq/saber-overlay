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
  solanaPackages =
    (import ./solana { inherit pkgs rustStable darwinPackages; });
in anchorPackages // solanaPackages // {
  spl-token-cli = pkgs.callPackage ./spl-token-cli.nix {
    inherit (rustNightly) rustPlatform;
    inherit (pkgs)
      lib clang llvm pkgconfig libudev openssl zlib stdenv fetchCrate;
    inherit (pkgs.llvmPackages) libclang;
    inherit darwinPackages;
  };

  cargo-workspaces = pkgs.callPackage ./cargo-workspaces.nix {
    inherit (rustNightly) rustPlatform;
    inherit (pkgs)
      lib pkgconfig libudev openssl zlib stdenv fetchCrate libssh2 libgit2;
    inherit darwinPackages;
  };

  rust-nightly = rustNightly.rust;
  rust-stable = rustStable.rust;
  saber-ci = import ./saber-ci.nix { inherit pkgs; };
}
