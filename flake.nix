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

      overlayBasic = import ./.;
      overlayWithRust = final: prev:
        (nixpkgs.lib.composeExtensions rustOverlay overlayBasic) final prev;
    in {
      overlay = overlayWithRust;
      overlays = {
        basic = overlayBasic;
        withRust = overlayWithRust;
      };
    } // flake-utils.lib.eachSystem [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlayWithRust ];
        };
        env = import ./env.nix { inherit pkgs; };
      in {
        packages = flake-utils.lib.flattenTree {
          inherit (pkgs)
            solana spl-token-cli anchor anchor-0_12_0 anchor-0_13_2;
          inherit (pkgs) saber;
        } // pkgs;
        devShell = import ./shell.nix { inherit pkgs; };
        defaultPackage = env;
      });
}
