{ rustPlatform
, darwinPackages
, pkgconfig
, openssl
, lib
, udev
, stdenv
, fetchFromGitHub
}:

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

      cargoBuildFlags = [ "--package=anchor-cli" ];

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
in
rec {
  anchor-0_24_2 = makeAnchorPackage {
    version = "0.24.2";
    srcHash = "sha256-UfH05WSQYAZelUmbtZSzRKa4I0M7du/w2b9rNBY1pAw=";
    cargoHash = "sha256-mPhJwaECzENFrK9GPdzF0U2SMhu0bCnOqgr2pY9ZUhE=";
    cargoPatches = [ ./cargo-0.24.2.patch ];
  };
  anchor-0_24_0 = makeAnchorPackage {
    version = "0.24.0";
    srcHash = "sha256-b4savT3i491j/HwVHXO3QAd08oy0fa4ZYW6Xm+xTDgY=";
    cargoHash = "sha256-tLKR19fUEPtYJA7s0kjA7F8S+0tB/viu2Fg1gYc0qaY=";
    cargoPatches = [ ./cargo-0.24.0.patch ];
  };
  anchor-0_24 = anchor-0_24_2;

  anchor-0_23_0 = makeAnchorPackage {
    version = "0.23.0";
    srcHash = "sha256-P9cnFkHK3avjH/z4ptAkeZ8gG5hhi19CfbuvAJvZKo0=";
    cargoHash = "sha256-X5wPDeUdNR2nNcOvoSdXwOT2K7KZLU/hCj4yCqkXrVg=";
    cargoPatches = [ ./cargo-0.23.0.patch ];
  };
  anchor-0_23 = anchor-0_23_0;

  anchor-0_22_0 = makeAnchorPackage {
    version = "0.22.0";
    srcHash = "sha256-uUDBTDss6cX7+v9Y9ttlp77PgeH0DQW+zluT6A8/il8=";
    cargoHash = "sha256-v+7C+H1fvOByTT8yOz9j9R2ThrVerQq/oaQrHnSHZAc=";
    cargoPatches = [ ./cargo-0.22.0.patch ];
  };
  anchor-0_22 = anchor-0_22_0;

  anchor-0_21_0 = makeAnchorPackage {
    version = "0.21.0";
    srcHash = "sha256-JnW8hpor1RldWQJDcRdKbJk1jgD6SoDb23PVfR+IKBk=";
    cargoHash = "sha256-VNrnfaOY8UvxnOexm7kH1b97zqKguxqxoK6GbgdHrp4=";
    cargoPatches = [ ./cargo-0.21.0.patch ];
  };
  anchor-0_21 = anchor-0_21_0;

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
  anchor-0_20 = anchor-0_20_1;

  anchor-0_19_0 = makeAnchorPackage {
    version = "0.19.0";
    srcHash = "sha256-mQJJew66Xfj1MGI2u2iRmy3fsYqeaBXJq/S6QyHygqM=";
    cargoHash = "sha256-nnQTAoJpfX96eSJf2sELB7m34lwsPJmbt5vA/QN7f58=";
    cargoPatches = [ ./cargo-0.19.0.patch ];
  };
  anchor-0_19 = anchor-0_19_0;

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
  anchor-0_18 = anchor-0_18_2;

  anchor-0_17_0 = makeAnchorPackage {
    version = "0.17.0";
    srcHash = "sha256-jINbIWnE8IlhkRRfidGMp6RlLGpFxvy+hIWQ9CXDtPQ=";
    cargoHash = "sha256-xKWITDeb2O8K7I5sS/s+AjXsC9oNeHbZGfMfEWbsxX0=";
    cargoPatches = [ ./cargo-0.17.0.patch ];
  };
  anchor-0_17 = anchor-0_17_0;

  anchor-0_16_1 = makeAnchorPackage {
    version = "0.16.1";
    srcHash = "sha256-/u/6fX0ho9pjtGqgCro79Nchok8M//Gj60FMU/Hwwqs=";
    cargoHash = "sha256-LuLj4mlz9P83te+6IffIwvHujU+ZQYueSVE2Czja/s4=";
    cargoPatches = [ ./cargo-0.16.1.patch ];
  };
  anchor-0_16 = anchor-0_16_1;

  anchor-0_15_0 = makeAnchorPackage {
    version = "0.15.0";
    srcHash = "sha256-X8omeI/WleNvi1hVbYTSwkkshINgf88wPrNyxNzMMcQ=";
    cargoHash = "sha256-iETRSWbAAng/rMytCFXdEBfXZ5DLzqfbkc2uv9e/M7g=";
  };
  anchor-0_15 = anchor-0_15_0;

  anchor-0_13_2 = makeAnchorPackage {
    version = "0.13.2";
    srcHash = "sha256-qSEfapJBuQKRUeJAH66WY+ZbXPG1M1KqCgMKtTWUsW0=";
    cargoHash = "sha256-ZYV93KqtY1L7q6VkzQjA8x1xUSTnWh2rbfQrQH9edbk=";
  };
  anchor-0_13 = anchor-0_13_2;

  anchor-0_12_0 = makeAnchorPackage {
    version = "0.12.0";
    srcHash = "sha256-87Q/mPF/7sLDiT9N1MqjEX5E3dsLJ+oO2iyx9RcsK1g=";
    cargoHash = "sha256-iaapemx8ZTdeDvDHfCxtrwUlo2U+Sr96EWWODeIMU1w=";
  };
  anchor-0_12 = anchor-0_12_0;

  anchor = anchor-0_24;
}
