final: prev:
let
  mkRust = rust: {
    inherit rust;
    rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });
  };
  rustNightly = mkRust prev.rust-bin.nightly."2021-09-24".minimal;
  rustStable = mkRust prev.rust-bin.stable.latest.minimal;
  saberPackages = (import ./packages {
    inherit rustNightly rustStable;
    pkgs = prev;
  });
in saberPackages
