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
        packages = flake-utils.lib.flattenTree pkgs.saberPackages;
        devShell = import ./shell.nix { inherit pkgs; };
        defaultPackage = env;
      });
}
