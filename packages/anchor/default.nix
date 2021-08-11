{ pkgs, rustPlatform ? pkgs.rustPlatform, darwinPackages }:

rustPlatform.buildRustPackage rec {
  pname = "anchor";
  version = "0.13.2";

  src = pkgs.fetchFromGitHub {
    owner = "project-serum";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qSEfapJBuQKRUeJAH66WY+ZbXPG1M1KqCgMKtTWUsW0=";
  };

  cargoSha256 = "sha256-ZYV93KqtY1L7q6VkzQjA8x1xUSTnWh2rbfQrQH9edbk=";
  verifyCargoDeps = false;

  nativeBuildInputs = with pkgs; [ pkgconfig ];
  buildInputs = with pkgs;
    [ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ]) ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
