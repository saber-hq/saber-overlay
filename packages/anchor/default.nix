{ pkgs, rustPlatform ? pkgs.rustPlatform, darwinPackages }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.12.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-87Q/mPF/7sLDiT9N1MqjEX5E3dsLJ+oO2iyx9RcsK1g=";
  };

  # cargoPatches = [
  #   # a patch file to add/update Cargo.lock in the source code
  #   ./fix-Cargo.lock.patch
  # ];
  cargoSha256 = "sha256-iaapemx8ZTdeDvDHfCxtrwUlo2U+Sr96EWWODeIMU1w=";
  verifyCargoDeps = false;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    [ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]) ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
