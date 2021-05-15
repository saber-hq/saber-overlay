{ pkgs, buildRustPackage ? pkgs.rustPlatform.buildRustPackage }:

buildRustPackage rec {
  pname = "anchor";
  version = "0.5.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iTY6/jKeuyt1GFUjffQVkcl/vW8IdtwZ4ly9/KF0MGA=";
  };

  cargoSha256 = "sha256-X8C/VZV7VS/yUe2gouiQKG+PBMWsASQlQBHpfjSLH+g=";
  verifyCargoDeps = true;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs; lib.optionals stdenv.isLinux [ libudev ];
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
