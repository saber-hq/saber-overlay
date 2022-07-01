final: prev:
let
  mkRust = rust: {
    inherit rust;
    rustPlatform = prev.recurseIntoAttrs (prev.makeRustPlatform {
      rustc = rust;
      cargo = rust;
    });
  };
  rustNightly = mkRust prev.rust-bin.nightly."2022-05-21".minimal;
  rust-1_60 = mkRust prev.rust-bin.stable."1.60.0".minimal;
  rustStable = mkRust prev.rust-bin.stable."1.61.0".minimal;
  saberPackages = (import ./packages {
    inherit rustNightly rustStable rust-1_60;
    pkgs = prev;
  });
in
saberPackages // {
  saber = saberPackages // {
    default = import ./env.nix { pkgs = prev // saberPackages; };
  };
}
