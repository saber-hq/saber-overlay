# nixpkgs-stableswap

Nix packages for Stableswap.

## Usage

```nix
let
    stableswapOverlay = fetchFromGitHub {
        owner = "stableswap";
        repo = "nixpkgs-stableswap";
        rev = "master";
        sha256 = "...";
    };
    nixpkgs = import <nixpkgs> { overlays = [ (import stableswapOverlay) ]; };
in
    with nixpkgs;
# ...
```
