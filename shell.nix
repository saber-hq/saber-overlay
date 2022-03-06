{ pkgs }:

with pkgs;
mkShell { buildInputs = [ (import ./env.nix { inherit pkgs; }) ]; }
