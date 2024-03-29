{ fetchCrate
, lib
, validatorOnly ? false
, rustPlatform
, clang
, llvm
, udev
, pkg-config
, openssl
, zlib
, libclang
, stdenv
, darwinPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "spl-token-cli";
  version = "2.0.15";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-w6ebIiI4BvAuebQLYk2uSCaVzJoFyxuBIEi9+D/pUWk=";
  };

  cargoSha256 = "sha256-v6jWcyHzHWa39McMLMgp1bzDSfkB6WE7H8VRTg7YPXg=";
  verifyCargoDeps = true;

  LIBCLANG_PATH = "${libclang}/lib";
  nativeBuildInputs = [ clang llvm pkg-config ];
  buildInputs = [ libclang openssl zlib ] ++ darwinPackages
    ++ (lib.optionals stdenv.isLinux [ udev ]);
  strictDeps = true;
}
