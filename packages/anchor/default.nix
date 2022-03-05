{ rustPlatform, darwinPackages, pkgconfig, openssl, lib, udev, stdenv
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
      buildInputs = [ openssl ] ++ darwinPackages
        ++ (lib.optionals stdenv.isLinux [ udev ]);
      strictDeps = true;

      # this is too slow
      doCheck = false;
    });
in rec {
  anchor-0_22_0 = makeAnchorPackage {
    version = "0.22.0";
    srcHash = "sha256-uUDBTDss6cX7+v9Y9ttlp77PgeH0DQW+zluT6A8/il8=";
    cargoHash = "sha256-v+7C+H1fvOByTT8yOz9j9R2ThrVerQq/oaQrHnSHZAc=";
    cargoPatches = [ ./cargo-0.22.0.patch ];
  };
  anchor-0_21_0 = makeAnchorPackage {
    version = "0.21.0";
    srcHash = "sha256-JnW8hpor1RldWQJDcRdKbJk1jgD6SoDb23PVfR+IKBk=";
    cargoHash = "sha256-VNrnfaOY8UvxnOexm7kH1b97zqKguxqxoK6GbgdHrp4=";
    cargoPatches = [ ./cargo-0.21.0.patch ];
  };
  anchor-0_20_1 = makeAnchorPackage {
    version = "0.20.1";
    srcHash = "sha256-KPz1mZWcNmgQmw/wR99zTjbsjvwY3xlX+SGKKShFJ8U=";
    cargoHash = "sha256-llrjj8tlehneYrNk2HZ4iulal+HlUb2vOgxbsmzAoG8=";
    cargoPatches = [ ./cargo-0.20.1.patch ];
  };
  anchor-0_20_0 = makeAnchorPackage {
    version = "0.20.0";
    srcHash = "sha256-w3hqCZJZXLl3Tanx3LkrLceqOp5A8Mp+Zt05Saewa9E=";
    cargoHash = "sha256-WeMXs3Y/HV0F/AjcdMrcHbfwehHlaj24mx5T69pV9YQ=";
    cargoPatches = [ ./cargo-0.20.0.patch ];
  };
  anchor-0_19_0 = makeAnchorPackage {
    version = "0.19.0";
    srcHash = "sha256-mQJJew66Xfj1MGI2u2iRmy3fsYqeaBXJq/S6QyHygqM=";
    cargoHash = "sha256-nnQTAoJpfX96eSJf2sELB7m34lwsPJmbt5vA/QN7f58=";
    cargoPatches = [ ./cargo-0.19.0.patch ];
  };
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
  anchor = anchor-0_22_0;
}
