{ pkgs, rustPlatform ? pkgs.rustPlatform, darwinPackages }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.8.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NmDaaRniiNb41Mw0Luql5/fCWs10PCj14iAyyBWcJE8=";
  };

  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    # ./fix-Cargo.lock.patch
  ];
  cargoSha256 = "sha256-EdfPRX+yU22IXvc5BUpXJunwHhYqZpxT9IuetoN0XqY=";
  verifyCargoDeps = false;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    [ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]) ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
