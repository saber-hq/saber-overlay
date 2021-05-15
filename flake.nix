{
  description = "Nix overlay for StableSwap projects.";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packages = (import ./default.nix) pkgs pkgs;
        env = import ./shell.nix { pkgs = pkgs // packages; };
      in {
        inherit packages;
        devShell = env;
        defaultPackage = env;
      });
}
