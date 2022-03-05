# saber-overlay

Overlay containing Saber packages.

## Usage

### Nix flakes (recommended)

```nix
{
  description = "My configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    saber-overlay.url = "github:saber-hq/saber-overlay";
  };

  outputs = { nixpkgs, saber-overlay, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix # Your system configuration.
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ saber-overlay.overlay ];
            environment.systemPackages = [ pkgs.saber.solana ];
          })
        ];
      };
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
