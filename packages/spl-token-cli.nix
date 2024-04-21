{ fetchCrate
, lib
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
  version = "3.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Ojm/zWTz7WIJ+HKXkYox5FP3vkYTR5jL5UvXrIicONQ=";
  };

  cargoSha256 = "sha256-GILGgcf2xo2cxKAP2gDakBwmNlhPgz/AcmbdighluSU=";
  verifyCargoDeps = true;

  LIBCLANG_PATH = "${libclang}/lib";
  nativeBuildInputs = [ clang llvm pkg-config ];
  buildInputs = [ libclang openssl zlib ] ++ darwinPackages
    ++ (lib.optionals stdenv.isLinux [ udev ]);
  strictDeps = true;
}
