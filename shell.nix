let pkgs = import <nixpkgs> { overlays = [ (import ./default.nix) ]; };
in with pkgs; mkShell { nativeBuildInputs = [ solana ]; }
