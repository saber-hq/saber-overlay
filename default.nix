final: prev:
let
  mkRust = rust: {
    inherit rust;
    rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });
  };
  rustNightly = mkRust prev.rust-bin.nightly."2021-06-09".default;
  rustStable = mkRust prev.rust-bin.stable.latest.default;
  saber = {
    inherit rustNightly rustStable;
  } // (import ./packages {
    inherit rustNightly rustStable;
    pkgs = prev;
  });
in {
  inherit saber;
  inherit (saber) solana spl-token-cli anchor;
}
