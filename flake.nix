{
  description = "Nix overlay for Saber projects.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    let
      rustOverlay = import rust-overlay;

      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];

      overlayBasic = import ./.;
      overlayWithRust = final: prev:
        (nixpkgs.lib.composeExtensions rustOverlay overlayBasic) final prev;
    in {
      inherit supportedSystems;
      overlay = overlayWithRust;
      overlays = {
        basic = overlayBasic;
        withRust = overlayWithRust;
      };
    } // flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlayWithRust ];
        };
        env = import ./env.nix { inherit pkgs; };
      in {
        packages = (flake-utils.lib.flattenTree pkgs.saberPackages)
          // (with pkgs.saberPackages; {
            solana-1_7_14-basic = solana-1_7_14.solana-basic;
            solana-1_7_14-full = solana-1_7_14.solana-full;
            solana-1_8_12-basic = solana-1_8_12.solana-basic;
            solana-1_8_12-full = solana-1_8_12.solana-full;
            solana-basic = solana.solana-basic;
            solana-full = solana.solana-full;
          });
        devShell = import ./shell.nix { inherit pkgs; };
        defaultPackage = env;
      });
}
