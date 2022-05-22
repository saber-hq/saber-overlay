{
  description = "Nix overlay for Saber projects.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    goki-cli.url = "github:GokiProtocol/goki-cli";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, goki-cli }:
    let
      rustOverlay = import rust-overlay;

      supportedSystems = flake-utils.lib.defaultSystems;

      overlayBasic = import ./overlay.nix;
      overlayWithRust = final: prev:
        (nixpkgs.lib.composeExtensions rustOverlay overlayBasic) final prev;

      systemOutputs = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              goki-cli.overlays.default
              overlayWithRust
            ];
          };
          env = import ./env.nix { inherit pkgs; };
        in
        {
          packages = pkgs.saber;
          devShells = {
            default = import ./shell.nix { inherit pkgs; };
          };
        });
    in
    {
      overlays = {
        default = overlayWithRust;
        basic = overlayBasic;
        withRust = overlayWithRust;
      };

      lib = rec {
        inherit supportedSystems;
        rustPlatformStable = overlayWithRust.rustStable.rustPlatform;
        buildFlakeOutputs = import ./lib/buildFlakeOutputs.nix {
          inherit nixpkgs flake-utils;
          inherit supportedSystems systemOutputs;
        };
        defaultFlakeOutputs = buildFlakeOutputs { };
      };
    } // systemOutputs;
}
