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
  rustStable = mkRust prev.rust-bin.stable."1.61.0".minimal;
  saberPackages = (import ./packages {
    inherit rustNightly rustStable;
    pkgs = prev;
  });

  packages = saberPackages // (with saberPackages; {
    inherit (prev) goki-cli;
  });
in
packages // {
  saber = packages // {
    default = import ./env.nix { pkgs = prev // packages; };
  };
}
