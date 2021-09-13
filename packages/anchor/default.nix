{ rustPlatform, darwinPackages, pkgconfig, openssl, libudev, lib, stdenv
, fetchFromGitHub }:

let
  makeAnchorPackage = { version, srcHash, cargoHash }:
    (rustPlatform.buildRustPackage rec {
      inherit version;
      pname = "anchor";

      src = fetchFromGitHub {
        owner = "project-serum";
        repo = pname;
        rev = "v${version}";
        sha256 = srcHash;
      };

      cargoSha256 = cargoHash;
      verifyCargoDeps = false;

      nativeBuildInputs = [ pkgconfig ];
      buildInputs = [ openssl ] ++ (lib.optionals stdenv.isLinux [ libudev ])
        ++ darwinPackages;
      strictDeps = true;

      # this is too slow
      doCheck = false;
    });
in rec {
  anchor-0_15_0 = makeAnchorPackage {
    version = "0.15.0";
    srcHash = "sha256-X8omeI/WleNvi1hVbYTSwkkshINgf88wPrNyxNzMMcQ=";
    cargoHash = "sha256-iETRSWbAAng/rMytCFXdEBfXZ5DLzqfbkc2uv9e/M7g=";
  };
  anchor-0_13_2 = makeAnchorPackage {
    version = "0.13.2";
    srcHash = "sha256-qSEfapJBuQKRUeJAH66WY+ZbXPG1M1KqCgMKtTWUsW0=";
    cargoHash = "sha256-ZYV93KqtY1L7q6VkzQjA8x1xUSTnWh2rbfQrQH9edbk=";
  };
  anchor-0_12_0 = makeAnchorPackage {
    version = "0.12.0";
    srcHash = "sha256-87Q/mPF/7sLDiT9N1MqjEX5E3dsLJ+oO2iyx9RcsK1g=";
    cargoHash = "sha256-iaapemx8ZTdeDvDHfCxtrwUlo2U+Sr96EWWODeIMU1w=";
  };
  anchor = anchor-0_15_0;
}
