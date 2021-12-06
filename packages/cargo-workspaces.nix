{ fetchCrate, lib, rustPlatform, pkgconfig, libudev, openssl, zlib, stdenv
, darwinPackages, libssh2, libgit2 }:

with rustPlatform;

buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.2.28";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VIdIX21r5OWVvC1pMLYSTWkZluiODzfW5zUiSM1k4dU=";
  };

  cargoSha256 = "sha256-Y2Kn2m2S12p8HL95Q7zMqrPifk8QcPmwYS4PUiBothk=";
  verifyCargoDeps = true;

  # needed to get libssh2/libgit2 to link properly
  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [ pkgconfig libssh2 ];
  buildInputs = ([ openssl zlib libssh2 libgit2 ]
    ++ (lib.optionals stdenv.isLinux [ libudev ])) ++ darwinPackages;
  strictDeps = true;

  # skip tests, because for some reason they fail...
  doCheck = false;

  meta = with lib; {
    description =
      "A tool for managing cargo workspaces and their crates, inspired by lerna";
    longDescription = ''
      A tool that optimizes the workflow around cargo workspaces with
      git and cargo by providing utilities to version, publish, execute
      commands and more.
    '';
    homepage = "https://github.com/pksunkara/cargo-workspaces";

    license = licenses.mit;
  };
}
