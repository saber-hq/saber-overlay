{ pkgs, rustPlatform ? pkgs.rustPlatform, IOKit, Security, CoreFoundation
, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.6.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vMV3rhpvb9segy0V4E8Ym/i8KeafBnb0dxfj3i6RkO0=";
  };

  cargoSha256 = "sha256-IL87MSBUUNUeDWCZDtcwP5pqgeQCBEsHjM94Q8vu/dE=";
  verifyCargoDeps = true;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    ([ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]) ++ (
      # Fix for usb-related segmentation faults on darwin
      lib.optionals stdenv.isDarwin [ IOKit Security CoreFoundation AppKit ]));
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
