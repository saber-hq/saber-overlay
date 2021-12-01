{ rustPlatform, darwinPackages, pkgconfig, openssl, libudev, lib, stdenv
, fetchFromGitHub }:

let
  makeAnchorPackage = { version, srcHash, cargoHash, cargoPatches ? [ ] }:
    (rustPlatform.buildRustPackage rec {
      inherit version;
      pname = "anchor";

      src = fetchFromGitHub {
        owner = "project-serum";
        repo = pname;
        rev = "v${version}";
        sha256 = srcHash;
      };

      inherit cargoPatches;
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
  anchor-0_18_2 = makeAnchorPackage {
    version = "0.18.2";
    srcHash = "sha256-q7Z5RFnj+pvAHitLU8A6EP8Iwqqradf5jOnZf7GiQHM=";
    cargoHash = "sha256-oRmVfMkEu0Van1un5/rFOFi2yUmivnGLRGdpp5Cp0Lk=";
    cargoPatches = [ ./cargo-0.18.2.patch ];
  };
  anchor-0_18_0 = makeAnchorPackage {
    version = "0.18.0";
    srcHash = "sha256-YYt/lFJUicV1cqyM1t4sAX7+78jaQWPr1Z6vRotkP+g=";
    cargoHash = "sha256-rCr7J6DHaMbnMsz7C6JkKz7o8sKDqNYa5VDzUhbKGoE=";
    cargoPatches = [ ./cargo-0.18.0.patch ];
  };
  anchor-0_17_0 = makeAnchorPackage {
    version = "0.17.0";
    srcHash = "sha256-jINbIWnE8IlhkRRfidGMp6RlLGpFxvy+hIWQ9CXDtPQ=";
    cargoHash = "sha256-xKWITDeb2O8K7I5sS/s+AjXsC9oNeHbZGfMfEWbsxX0=";
    cargoPatches = [ ./cargo-0.17.0.patch ];
  };
  anchor-0_16_1 = makeAnchorPackage {
    version = "0.16.1";
    srcHash = "sha256-/u/6fX0ho9pjtGqgCro79Nchok8M//Gj60FMU/Hwwqs=";
    cargoHash = "sha256-LuLj4mlz9P83te+6IffIwvHujU+ZQYueSVE2Czja/s4=";
    cargoPatches = [ ./cargo-0.16.1.patch ];
  };
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
  anchor = anchor-0_18_2;
}
