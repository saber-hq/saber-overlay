{ pkgs, rustPlatform ? pkgs.rustPlatform, darwinPackages }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.7.0";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3JdSjaGBCY/jV38RPeiVQZWkV8gGok8Od5Hl9O8QML4=";
  };

  patches = [
    # a patch file to add/update Cargo.lock in the source code
    ./fix-Cargo.lock.patch
  ];
  cargoSha256 = "sha256-iO/taWqyPww0yN24ZHKcOEZSBklMPsKiRBxxn+/aorc=";
  verifyCargoDeps = true;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    [ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]) ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
