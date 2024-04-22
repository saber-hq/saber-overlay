{ fetchCrate
, lib
, rustPlatform
, clang
, llvm
, udev
, pkg-config
, protobuf
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

  nativeBuildInputs = [ clang llvm pkg-config protobuf ];
  buildInputs = [
    rustPlatform.bindgenHook
    libclang
    openssl
    zlib
  ] ++ darwinPackages
  ++ (lib.optionals stdenv.isLinux [ udev ]);
  strictDeps = true;

  # Tests build bpf stuff, which we don't need
  doCheck = false;

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;
}
