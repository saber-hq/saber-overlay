# saber-overlay

Overlay containing Saber packages.

## Usage

### Nix flakes (recommended)

```nix
{
  description = "My development environment.";

  inputs = {
    saber-overlay.url = "github:saber-hq/saber-overlay";
  };

  outputs = { self, saber-overlay }: saber-overlay.lib.defaultFlakeOutputs;
}
```

or

```nix
{
  description = "My development environment.";

  inputs = {
    saber-overlay.url = "github:saber-hq/saber-overlay";
  };

  outputs = { self, saber-overlay }: saber-overlay.lib.buildFlakeOutputs {
    setupBuildTools = { pkgs }: {
      anchor = pkgs.anchor-0_23_0;
    };
  };
}
```

### Overlay

```nix
let
    saberOverlay = fetchFromGitHub {
        owner = "saber-hq";
        repo = "saber-overlay";
        rev = "master";
        sha256 = "...";
    };
    nixpkgs = import <nixpkgs> { overlays = [ (import saberOverlay) ]; };
in
    with nixpkgs;
# ...
```

## TODO

- [ ] Make program compilation work on NixOS

## Other useful links

- https://github.com/cideM/solana-nix
