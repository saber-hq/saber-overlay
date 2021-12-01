final: prev:
let
  mkRust = rust: {
    inherit rust;
    rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });
  };
  rustNightly = mkRust prev.rust-bin.nightly."2021-11-30".minimal;
  rustStable = mkRust prev.rust-bin.stable."1.56.1".minimal;
  saberPackages = (import ./packages {
    inherit rustNightly rustStable;
    pkgs = prev;
  });
in saberPackages // { inherit saberPackages; }
