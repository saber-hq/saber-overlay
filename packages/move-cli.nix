{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, openssl
, zlib
, stdenv
, darwinPackages
, libssh2
, libgit2
}:

with rustPlatform;

buildRustPackage rec {
  pname = "move";
  version = "ae12f353227a01da84efeec99943c6185afec338";

  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = version;
    sha256 = "sha256-cyXxLEEHRpzmymX+WPKvtx/FDip1eiMIpbW47bJBxfc=";
  };

  cargoSha256 = "sha256-67jz3KBYJ0MwAlh/OMS0cgOhJq+3tba/EqKI4TqiqRs=";
  verifyCargoDeps = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl zlib ] ++ darwinPackages;
  strictDeps = true;

  doCheck = false;

  meta = with lib; {
    description =
      "CLI frontend for the Move compiler and VM";
    homepage = "https://diem.com";

    license = licenses.mit;
  };
}
