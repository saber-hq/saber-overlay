{
  description = "Nix overlay for Saber projects.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
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
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlayWithRust ];
        };
        env = import ./env.nix { inherit pkgs; };
      in {
        packages = flake-utils.lib.flattenTree { saber = pkgs.saber; };
        devShell = import ./shell.nix { inherit pkgs; };
        defaultPackage = env;
      });
}
