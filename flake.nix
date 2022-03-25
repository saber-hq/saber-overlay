{
  description = "Nix overlay for Saber projects.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    let
      rustOverlay = import rust-overlay;

      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];

      overlayBasic = import ./.;
      overlayWithRust = final: prev:
        (nixpkgs.lib.composeExtensions rustOverlay overlayBasic) final prev;

      systemOutputs = flake-utils.lib.eachSystem supportedSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlayWithRust ];
          };
          env = import ./env.nix { inherit pkgs; };
        in
        {
          inherit (pkgs) saberPackages;
          packages = (flake-utils.lib.flattenTree pkgs.saberPackages)
            // (with pkgs.saberPackages; {
            solana-1_7-basic = solana-1_7.solana-basic;
            solana-1_7-full = solana-1_7.solana-full;

            solana-1_8-basic = solana-1_8.solana-basic;
            solana-1_8-full = solana-1_8.solana-full;

            solana-1_9-basic = solana-1_9.solana-basic;
            solana-1_9-full = solana-1_9.solana-full;

            solana-1_10-basic = solana-1_10.solana-basic;
            solana-1_10-full = solana-1_10.solana-full;

            solana-basic = solana.solana-basic;
            solana-full = solana.solana-full;
          });
          devShell = import ./shell.nix { inherit pkgs; };
          defaultPackage = env;
        });
    in
    {
      overlay = overlayWithRust;
      overlays = {
        basic = overlayBasic;
        withRust = overlayWithRust;
      };

      lib = {
        inherit supportedSystems;
        rustPlatformStable = overlayWithRust.rustStable.rustPlatform;
        buildFlakeOutputs = import ./lib/buildFlakeOutputs.nix {
          inherit nixpkgs flake-utils;
          inherit supportedSystems systemOutputs;
        };
      };
    } // systemOutputs;
}
