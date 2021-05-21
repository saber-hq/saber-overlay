final: prev:
let
  rust = prev.rust-bin.stable.latest.default;
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
