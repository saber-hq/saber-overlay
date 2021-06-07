{ fetchCrate, lib, validatorOnly ? false, rustPlatform, IOKit, Security
, CoreFoundation, AppKit, clang, llvm, pkgconfig, libudev, openssl, zlib, System
, libclang, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "spl-token-cli";
  version = "2.0.11";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-L3seP1m6vbVR26zVlWaj9DFL0Pv3jhIKfhWqEU99r1I=";
  };

  cargoSha256 = "sha256-sZit1sgEljqO2XEOtxIkApnuAyQ0zfMbGFo5j+g6NEI=";
  verifyCargoDeps = true;

  LIBCLANG_PATH = "${libclang}/lib";
  nativeBuildInputs = [ clang llvm pkgconfig ];
  buildInputs = ([ openssl zlib ] ++ (lib.optionals stdenv.isLinux [ libudev ]))
    ++ (lib.optionals stdenv.isDarwin [
      IOKit
      Security
      CoreFoundation
      AppKit
      System
    ]);
  strictDeps = true;
}
