_: pkgs: {
  stableswap = rec {
    rust = pkgs.rust-bin.stable.latest.default;
    rustPlatform = pkgs.recurseIntoAttrs (pkgs.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });

    solana =
      pkgs.callPackage ./packages/solana.nix { inherit rustPlatform pkgs; };

    anchor = pkgs.callPackage ./packages/anchor.nix {
      inherit rustPlatform pkgs;
      inherit (pkgs.darwin.apple_sdk.frameworks) IOKit;
    };
  };
}
