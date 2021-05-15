_: pkgs: {
  stableswap = rec {
    rustChannel = pkgs.rustChannelOf {
      sha256 = "sha256-6eRkXrYqS/7BYlx7OBw44/phnDKN6l9IZjSt3eh78ZQ=";
      date = "2021-05-10";
      channel = "stable";
    };

    rustc = rustChannel.rust;
    cargo = rustChannel.cargo;
    buildRustPackage = pkgs.rustPlatform.buildRustPackage.override {
      inherit cargo rustc;
      fetchCargoTarball =
        pkgs.rustPlatform.fetchCargoTarball.override { inherit cargo; };
    };

    solana =
      pkgs.callPackage ./packages/solana.nix { inherit buildRustPackage pkgs; };

    anchor =
      pkgs.callPackage ./packages/anchor.nix { inherit buildRustPackage pkgs; };
  };
}
