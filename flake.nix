{
  description = "Nix overlay for StableSwap projects.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/release-20.09";
  inputs.nixpkgs-mozilla = {
    url = "github:mozilla/nixpkgs-mozilla";
    flake = false;
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixpkgs-mozilla, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import "${nixpkgs-mozilla}/rust-overlay.nix")
            (import ./default.nix)
          ];
        };
        env = import ./shell.nix { inherit pkgs; };
      in {
        packages = env.nativeBuildInputs;
        devShell = env;
        defaultPackage = env;
      });
}
