{ pkgs, rustPlatform ? pkgs.rustPlatform, subPackages ? [ "anchor" ] }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.5.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iTY6/jKeuyt1GFUjffQVkcl/vW8IdtwZ4ly9/KF0MGA=";
  };

  cargoSha256 = "sha256-6oBZphabvj1vOcrR03xq0uocRQShkVs3EzRw9iHDTvo=";
  verifyCargoDeps = true;

  cargoBuildFlags = builtins.map (name: "--bin=${name}") subPackages;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    ([ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]));
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
