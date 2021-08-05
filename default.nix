final: prev:
let
  mkRust = rust: {
    inherit rust;
    rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });
  };
  rustNightly = mkRust prev.rust-bin.nightly."2021-08-01".minimal;
  rustStable = mkRust prev.rust-bin.stable.latest.minimal;
  rustfmt = mkRust prev.rust-bin.stable.latest.rustfmt;
  saber = {
    inherit rustNightly rustStable;
  } // (import ./packages {
    inherit rustNightly rustStable rustfmt;
    pkgs = prev;
  });
in {
  inherit saber;
  inherit (saber) solana spl-token-cli anchor;
}
