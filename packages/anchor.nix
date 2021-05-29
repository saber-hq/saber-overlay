{ pkgs, rustPlatform ? pkgs.rustPlatform, IOKit, Security, CoreFoundation
, AppKit }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.6.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iTY6/jKeuyt1GFUjffQVkcl/vW8IdtwZ4ly9/KF0MGA=";
  };

  cargoSha256 = "sha256-6zoucTtjgH+PhovkkyS/Y9tkcFLzzKEHR1P7jcvAto0=";
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
