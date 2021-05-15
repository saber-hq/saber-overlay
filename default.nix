_: pkgs: { solana = pkgs.callPackage ./packages/solana.nix { inherit pkgs; }; }
