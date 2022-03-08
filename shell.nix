{ pkgs }:

pkgs.mkShell rec {
  buildInputs = [ (import ./env.nix { inherit pkgs; }) ];
}
