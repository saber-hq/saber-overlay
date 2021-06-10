final: prev:
let
  rust = prev.rust-bin.nightly."2021-06-09".default;
  rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
    rustc = rust;
    cargo = rust;
  });
  saber = {
    inherit rust rustPlatform;
  } // (import ./packages {
    inherit rustPlatform;
    pkgs = prev;
  });
in {
  inherit saber;
  inherit (saber) solana spl-token-cli anchor;
}
