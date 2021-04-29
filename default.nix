_: pkgs: {
  solana = import ./solana.nix { inherit pkgs; };
  solana-validator-only = import ./solana.nix {
    inherit pkgs;
    validatorOnly = true;
  };
}
