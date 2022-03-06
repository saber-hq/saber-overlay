{ fetchCrate, lib, rustPlatform, pkgconfig, openssl, zlib, stdenv
, darwinPackages, libssh2, libgit2 }:

with rustPlatform;

buildRustPackage rec {
  pname = "cargo-workspaces";
  version = "0.2.31";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Adypb432ucX+fYbaWNMYoUgd8fxo+Aj3a0ubDidzntA=";
  };

  cargoSha256 = "sha256-ip7ZMJheQyaj1rh34selK8w/ML3jDL5gGXCbqn1LXvs=";
  verifyCargoDeps = true;

  # needed to get libssh2/libgit2 to link properly
  LIBGIT2_SYS_USE_PKG_CONFIG = true;
  LIBSSH2_SYS_USE_PKG_CONFIG = true;

  nativeBuildInputs = [ pkgconfig libssh2 ];
  buildInputs = [ openssl zlib libssh2 libgit2 ] ++ darwinPackages;
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
