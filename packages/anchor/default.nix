{ rustPlatform
, darwinPackages
, pkg-config
, openssl
, lib
, udev
, stdenv
, fetchFromGitHub
}:

let
  makeAnchorPackage =
    { version
    , srcHash
    , cargoPatches ? [ ]
    , cargoOutputHashes ? { }
    }:
    (rustPlatform.buildRustPackage rec {
      inherit version;
      pname = "anchor";

      src = fetchFromGitHub {
        owner = "coral-xyz";
        repo = pname;
        rev = "v${version}";
        sha256 = srcHash;
      };

      cargoBuildFlags = [ "--package=anchor-cli" ];

      inherit cargoPatches;
      cargoLock = {
        lockFile = ./cargo/v${version}/Cargo.lock;
        outputHashes = cargoOutputHashes;
      };

      nativeBuildInputs = [ pkg-config ];
      buildInputs = [ openssl ] ++ darwinPackages
        ++ (lib.optionals stdenv.isLinux [ udev ]);
      strictDeps = true;

      # this is too slow
      doCheck = false;
    });
in
rec {
  anchor-0_29_0 = makeAnchorPackage {
    version = "0.29.0";
    srcHash = "sha256-mftge1idALb4vwyF8wGo6qLmrnvCBK3l+Iw7txCyhDc=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
    };
  };
  anchor-0_29 = anchor-0_29_0;

  anchor-0_28_0 = makeAnchorPackage {
    version = "0.28.0";
    srcHash = "sha256-WjGzFc0892LObdwwWP5uKrxwCT3y8CW8A/KvlpYGSrw=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
    };
  };
  anchor-0_28 = anchor-0_28_0;

  anchor-0_27_0 = makeAnchorPackage {
    version = "0.27.0";
    srcHash = "sha256-Oe4amhOit4iFfbbUIzx5qJ1ldlj94lGcIuXVYHX3IM4=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
    };
  };
  anchor-0_27 = anchor-0_27_0;

  anchor-0_26_0 = makeAnchorPackage {
    version = "0.26.0";
    srcHash = "sha256-u+M093cGy8cEWLg8oObKqSkWLyQC6G3S1TNhRBX6OV4=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
    };
  };
  anchor-0_26 = anchor-0_26_0;

  anchor-0_25_0 = makeAnchorPackage {
    version = "0.25.0";
    srcHash = "sha256-12Wmz7LK2ziZV94sx4tHmoj/VTO7ttxXNcGjAMQNtQI=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
    };
  };
  anchor-0_25 = anchor-0_25_0;

  anchor-0_24_2 = makeAnchorPackage {
    version = "0.24.2";
    srcHash = "sha256-UfH05WSQYAZelUmbtZSzRKa4I0M7du/w2b9rNBY1pAw=";
    cargoPatches = [ ./patches/cargo-0.24.2.patch ];
  };
  anchor-0_24_0 = makeAnchorPackage {
    version = "0.24.0";
    srcHash = "sha256-b4savT3i491j/HwVHXO3QAd08oy0fa4ZYW6Xm+xTDgY=";
    cargoPatches = [ ./patches/cargo-0.24.0.patch ];
  };
  anchor-0_24 = anchor-0_24_2;

  anchor-0_23_0 = makeAnchorPackage {
    version = "0.23.0";
    srcHash = "sha256-P9cnFkHK3avjH/z4ptAkeZ8gG5hhi19CfbuvAJvZKo0=";
    cargoPatches = [ ./patches/cargo-0.23.0.patch ];
    cargoOutputHashes = {
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_23 = anchor-0_23_0;

  anchor-0_22_0 = makeAnchorPackage {
    version = "0.22.0";
    srcHash = "sha256-uUDBTDss6cX7+v9Y9ttlp77PgeH0DQW+zluT6A8/il8=";
    cargoPatches = [ ./patches/cargo-0.22.0.patch ];
    cargoOutputHashes = {
      "serum_dex-0.5.5" = "";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_22 = anchor-0_22_0;

  anchor-0_21_0 = makeAnchorPackage {
    version = "0.21.0";
    srcHash = "sha256-JnW8hpor1RldWQJDcRdKbJk1jgD6SoDb23PVfR+IKBk=";
    cargoPatches = [ ./patches/cargo-0.21.0.patch ];
    cargoOutputHashes = {
      "serum_dex-0.5.5" = "";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_21 = anchor-0_21_0;

  anchor-0_20_1 = makeAnchorPackage {
    version = "0.20.1";
    srcHash = "sha256-KPz1mZWcNmgQmw/wR99zTjbsjvwY3xlX+SGKKShFJ8U=";
    cargoPatches = [ ./patches/cargo-0.20.1.patch ];
    cargoOutputHashes = {
      "serum_dex-0.5.2" = "";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_20_0 = makeAnchorPackage {
    version = "0.20.0";
    srcHash = "sha256-w3hqCZJZXLl3Tanx3LkrLceqOp5A8Mp+Zt05Saewa9E=";
    cargoPatches = [ ./patches/cargo-0.20.0.patch ];
    cargoOutputHashes = {
      "serum_dex-0.5.2" = "";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_20 = anchor-0_20_1;

  anchor-0_19_0 = makeAnchorPackage {
    version = "0.19.0";
    srcHash = "sha256-mQJJew66Xfj1MGI2u2iRmy3fsYqeaBXJq/S6QyHygqM=";
    cargoPatches = [ ./patches/cargo-0.19.0.patch ];
    cargoOutputHashes = {
      "serum_dex-0.5.1" = "sha256-eTcPjMeyZv6y4kMWvZ4/Y4sfA6mPwEPXLT2ZmMPpeHU=";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_19 = anchor-0_19_0;

  anchor-0_18_2 = makeAnchorPackage {
    version = "0.18.2";
    srcHash = "sha256-q7Z5RFnj+pvAHitLU8A6EP8Iwqqradf5jOnZf7GiQHM=";
    cargoPatches = [ ./patches/cargo-0.18.2.patch ];
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-+6W+aeH3s2tqf6G9i7dGCJkMP9Zps+4Pj5ps3UUsnW4=";
      "serum-common-0.1.0" = "sha256-tbPE8BijjfQREvI01iAZ7wsJjRx6YWAS4yYVddPDHyI=";
    };
  };
  anchor-0_18_0 = makeAnchorPackage {
    version = "0.18.0";
    srcHash = "sha256-YYt/lFJUicV1cqyM1t4sAX7+78jaQWPr1Z6vRotkP+g=";
    cargoPatches = [ ./patches/cargo-0.18.0.patch ];
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
      "serum-common-0.1.0" = "sha256-tbPE8BijjfQREvI01iAZ7wsJjRx6YWAS4yYVddPDHyI=";
    };
  };
  anchor-0_18 = anchor-0_18_2;

  anchor-0_17_0 = makeAnchorPackage {
    version = "0.17.0";
    srcHash = "sha256-jINbIWnE8IlhkRRfidGMp6RlLGpFxvy+hIWQ9CXDtPQ=";
    cargoPatches = [ ./patches/cargo-0.17.0.patch ];
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_17 = anchor-0_17_0;

  anchor-0_16_1 = makeAnchorPackage {
    version = "0.16.1";
    srcHash = "sha256-/u/6fX0ho9pjtGqgCro79Nchok8M//Gj60FMU/Hwwqs=";
    cargoPatches = [ ./patches/cargo-0.16.1.patch ];
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_16 = anchor-0_16_1;

  anchor-0_15_0 = makeAnchorPackage {
    version = "0.15.0";
    srcHash = "sha256-X8omeI/WleNvi1hVbYTSwkkshINgf88wPrNyxNzMMcQ=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_15 = anchor-0_15_0;

  anchor-0_13_2 = makeAnchorPackage {
    version = "0.13.2";
    srcHash = "sha256-qSEfapJBuQKRUeJAH66WY+ZbXPG1M1KqCgMKtTWUsW0=";
    cargoOutputHashes = {
      "serum_dex-0.4.0" = "sha256-Nzhh3OcAFE2LcbUgrA4zE2TnUMfV0dD4iH6fTi48GcI=";
      "serum-common-0.1.0" = "";
    };
  };
  anchor-0_13 = anchor-0_13_2;

  anchor-0_12_0 = makeAnchorPackage {
    version = "0.12.0";
    srcHash = "sha256-87Q/mPF/7sLDiT9N1MqjEX5E3dsLJ+oO2iyx9RcsK1g=";
    cargoOutputHashes = {
      "serum-common-0.1.0" = "sha256-IfPdA9Zg5x4Gd1ibhHI9JQ8ZH2q/vB1c0wBIiGaGMEY=";
    };
  };
  anchor-0_12 = anchor-0_12_0;

  anchor = anchor-0_29;
}
