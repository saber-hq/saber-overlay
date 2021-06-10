final: prev:
let
  rust = prev.rust-bin.nightly."2021-06-09".default;
  rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
    rustc = rust;
    cargo = rust;
  });
in {
  stableswap = {
    inherit rust rustPlatform;
  } // (import ./packages {
    inherit rustPlatform;
    pkgs = prev;
  });
}
