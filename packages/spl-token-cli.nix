{ fetchCrate, lib, validatorOnly ? false, rustPlatform, clang, llvm, pkgconfig
, libudev, openssl, zlib, libclang, stdenv, darwinPackages }:

rustPlatform.buildRustPackage rec {
  pname = "spl-token-cli";
  version = "2.0.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-fdWQ9BE6q0fC7hOe8OAWeL6tu+fEdsGlKUbTd03O3yw=";
  };

  cargoSha256 = "sha256-tQ174s05PURD85BcdaaIOvJYgegGPcufnJl7tqVt7iM=";
  verifyCargoDeps = true;

  LIBCLANG_PATH = "${libclang}/lib";
  nativeBuildInputs = [ clang llvm pkgconfig ];
  buildInputs =
    ([ libclang openssl zlib ] ++ (lib.optionals stdenv.isLinux [ libudev ]))
    ++ darwinPackages;
  strictDeps = true;
}
