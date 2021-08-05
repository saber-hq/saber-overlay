{ pkgs, rustPlatform ? pkgs.rustPlatform, darwinPackages }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.11.1";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZwYv3XZujMCcQUgd1AHn0xNE1TMcakm5PNsNrGe8LVU=";
  };

  cargoPatches = [
    # a patch file to add/update Cargo.lock in the source code
    ./fix-Cargo.lock.patch
  ];
  cargoSha256 = "sha256-KNyb26+ZyNe9latyN5AlqglORQ0ZVLpzs7s7vhlXxc8=";
  verifyCargoDeps = false;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    [ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]) ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
