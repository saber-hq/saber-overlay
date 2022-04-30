{ fetchFromGitHub
, lib
, rustPlatform
, pkgconfig
, openssl
, zlib
, darwinPackages
, enableAddress32 ? false
}:

with rustPlatform;

buildRustPackage rec {
  pname = "move";
  version = "c2ced3f9571176bd1df5946c1cdb8f40bbdb18d4";

  src = fetchFromGitHub {
    owner = "move-language";
    repo = "move";
    rev = version;
    sha256 = "sha256-24qIPFX5fUi7AEdYT4qfX+BeTFrreGloII2tljOwDm0=";
  };

  buildFeatures = lib.optionals enableAddress32 [ "address32" ];

  cargoSha256 = "sha256-cuoQDOBhEzrDUaJOqJzDgb3FNyU7D1Rp5wOzZJp5KoI=";
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
