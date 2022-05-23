# saber-overlay

Overlay containing Nix packages used within the Saber ecosystem.

## Usage

### Nix flakes (recommended)

The following helper exports several packages:

- `env-anchor-idls` - environment which allows the use of the `anchor idl` command
- `env-anchor-build` - exposes tools to create verifiable Anchor builds
- `rust` - exposes Cargo/Rustc as used in CI

To use these in GitHub Actions, you may reference [the Saber Periphery GitHub actions](https://github.com/saber-hq/saber-periphery/blob/master/.github/workflows) and pick one of the below flake formats:

```nix
{
  description = "My development environment.";

  inputs = {
    saber-overlay.url = "github:saber-hq/saber-overlay";
  };

  outputs = { self, saber-overlay }: saber-overlay.lib.defaultFlakeOutputs;
}
```

#### Locking a specific Anchor/Solana version

```nix
{
  description = "My development environment.";

  inputs = {
    saber-overlay.url = "github:saber-hq/saber-overlay";
  };

  outputs = { self, saber-overlay }: saber-overlay.lib.buildFlakeOutputs {
    setupBuildTools = { pkgs }: {
      solana = pkgs.solana-1_9;
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
