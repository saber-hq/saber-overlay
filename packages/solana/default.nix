{ pkgs, rustStable, darwinPackages }:
let
  mkSolana = (args:
    import ./solana-packages.nix {
      inherit pkgs rustStable darwinPackages;
      inherit (args) version githubSha256 cargoHashes;
    });
in
rec {
  solana-1_7_14 = mkSolana {
    version = "1.7.14";
    githubSha256 = "sha256-oEGYrAdSvS2W2AjUNOUHK4IeSzGWWDzQTmE2zkDFQVM=";
    cargoHashes = {
      solana-full = "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU=";
      solana-basic = "sha256-qsY1/xk90gQ3fQtGwdkPGDWYAHR3CttJ7r692e1Mpno=";
    };
  };
  solana-1_7_17 = mkSolana {
    version = "1.7.17";
    githubSha256 = "sha256-PSAalxB9pHFHoUfw5UvpGWqmURT/3R3jK6PdMQoiDXc=";
    cargoHashes = {
      solana-full = "sha256-Gbf0lpMmhEv//uRWWOBXbwm0FBueD/kK6k3Cljxc0Gk=";
      solana-basic = "sha256-J/Wvbp50cUDw07eYNOLniE5N8zIQ/0iE6pWhSsuIORc=";
    };
  };
  solana-1_7 = solana-1_7_17;

  solana-1_8_12 = mkSolana {
    version = "1.8.12";
    githubSha256 = "sha256-aY1mYxQ9NZtb+TuZrLNUCm2IS23WygY7vcmgPnSRa3w=";
    cargoHashes = {
      solana-full = "sha256-vuqpC3ts92RPpQ/vy/OBDW0heL/3EfhAZhddsW5A2tA=";
      solana-basic = "sha256-h6uqKCTrWJz/83HP5VhMShvcZQn6IVUaRNpnbGUnXTk=";
    };
  };
  solana-1_8_16 = mkSolana {
    version = "1.8.16";
    githubSha256 = "sha256-bU76hCsKlPCcTvEFJh95CIEzz47QlmU4mpFZXpP/erc=";
    cargoHashes = {
      solana-full = "sha256-E6K/kb2ScClo+BpJJLrYvB6omQcPhNY/hizINlNkCWk=";
      solana-basic = "sha256-pGqt30UivScwsNnmdTfqGajCSmB6hCrk7SJgUnC9iHg=";
    };
  };
  solana-1_8 = solana-1_8_16;

  solana-1_9_9 = mkSolana {
    version = "1.9.9";
    githubSha256 = "sha256-Xac1kQFWmmBEkN175ppevCJeeupKvztOgy90FyM5Ca0=";
    cargoHashes = {
      solana-full = "sha256-QM3OsHHCBNWXlk+LTzBVRQNEY5TlGvEkfeihpbvUtrE=";
      solana-basic = "sha256-v6fVYYJJ1MnffmnnuP3f7KHb9md0s9OvdjCd+oab/TI=";
    };
  };
  solana-1_9_12 = mkSolana {
    version = "1.9.12";
    githubSha256 = "sha256-1j/kULI+X4VfHgm0OnBmgMIccPvXW6z5LmJ2i4kVpA4=";
    cargoHashes = {
      solana-full = "sha256-LHhUc4FM9Vo4QcBStNyDXAnJhNRWkKQSmnuwcQEcIvE=";
      solana-basic = "sha256-b7QeAsFvwLfvFlHvD+YA2R0TCEdkaD9VBjPj8xn/Eio=";
    };
  };
  solana-1_9_22 = mkSolana {
    version = "1.9.22";
    githubSha256 = "sha256-hdB/iKCMZqFo9kUWSxVZfqjJ7HH6qj1jRqcMd5ZQf7M=";
    cargoHashes = {
      solana-full = "sha256-w1Tcn1nZDDWcHfVUlemLYAKuDWHlIhHKCk/EOP4auRI=";
      solana-basic = "sha256-ZqCnksil7mP8ucW+zgSzYZYAuomZEr+F9jK0IZojZsk=";
    };
  };
  solana-1_9 = solana-1_9_22;

  solana-1_10_0 = mkSolana {
    version = "1.10.0";
    githubSha256 = "sha256-4XKvhHEr/eo+jZd0ElBDI0/tYBnQBGr3pgNk5mdVAaI=";
    cargoHashes = {
      solana-full = "sha256-MuLC1rqWTbC10tz647SkXXQRB/EI37qDdqYn10KjjTk=";
      solana-basic = "sha256-y4q4MRnvThrfloXt7WkDO8/YIl81QtC1vgVdpjjXNWU=";
    };
  };
  solana-1_10_17 = mkSolana {
    version = "1.10.17";
    githubSha256 = "sha256-iiBbmpiNGow6vfKvkMv+1vNPRk/GKCoehCdbbtn8MU4=";
    cargoHashes = {
      solana-full = "sha256-W/wJT/Og0AwyZyywxtuGm7888fvmcE4UOWC4LE6Iqwk=";
      solana-basic = "sha256-IFOEP2AZ2mLvlOGc4J9I9HHJuTzRd4aeythPPO5+8Ks=";
    };
  };
  solana-1_10 = solana-1_10_17;

  solana = solana-1_10;
}
