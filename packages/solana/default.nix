{ pkgs, rustStable, darwinPackages, rust-1_60 }:
let
  mkSolana = (
    { rust ? rustStable, ... }@args:
    import ./solana-packages.nix {
      inherit pkgs rust darwinPackages;
      inherit (args) version githubSha256 cargoHashes;
    }
  );
in
rec {
  solana-1_7_14 = mkSolana {
    version = "1.7.14";
    githubSha256 = "sha256-oEGYrAdSvS2W2AjUNOUHK4IeSzGWWDzQTmE2zkDFQVM=";
    cargoHashes = {
      solana-full = "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU=";
      solana-basic = "sha256-qsY1/xk90gQ3fQtGwdkPGDWYAHR3CttJ7r692e1Mpno=";
    };
    rust = rust-1_60;
  };
  solana-1_7_17 = mkSolana {
    version = "1.7.17";
    githubSha256 = "sha256-PSAalxB9pHFHoUfw5UvpGWqmURT/3R3jK6PdMQoiDXc=";
    cargoHashes = {
      solana-full = "sha256-Gbf0lpMmhEv//uRWWOBXbwm0FBueD/kK6k3Cljxc0Gk=";
      solana-basic = "sha256-J/Wvbp50cUDw07eYNOLniE5N8zIQ/0iE6pWhSsuIORc=";
    };
    rust = rust-1_60;
  };
  solana-1_7 = solana-1_7_17;

  solana-1_8_12 = mkSolana {
    version = "1.8.12";
    githubSha256 = "sha256-aY1mYxQ9NZtb+TuZrLNUCm2IS23WygY7vcmgPnSRa3w=";
    cargoHashes = {
      solana-full = "sha256-vuqpC3ts92RPpQ/vy/OBDW0heL/3EfhAZhddsW5A2tA=";
      solana-basic = "sha256-h6uqKCTrWJz/83HP5VhMShvcZQn6IVUaRNpnbGUnXTk=";
    };
    rust = rust-1_60;
  };
  solana-1_8_16 = mkSolana {
    version = "1.8.16";
    githubSha256 = "sha256-bU76hCsKlPCcTvEFJh95CIEzz47QlmU4mpFZXpP/erc=";
    cargoHashes = {
      solana-full = "sha256-E6K/kb2ScClo+BpJJLrYvB6omQcPhNY/hizINlNkCWk=";
      solana-basic = "sha256-pGqt30UivScwsNnmdTfqGajCSmB6hCrk7SJgUnC9iHg=";
    };
    rust = rust-1_60;
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
  solana-1_9_28 = mkSolana {
    version = "1.9.28";
    githubSha256 = "sha256-r11K/3XajpIKuqb8mBvn0ynvMx5jtTjhOTZFxb0x2no=";
    cargoHashes = {
      solana-full = "sha256-0a/dRAMd8BFFefr7pMh08OyPf7H5VuXU9nHxUHBXWsY=";
      solana-basic = "sha256-SUzWADF7r119jY4PQp/1DwlkTCEdnGE01U5tSkzH/6s=";
    };
  };
  solana-1_9 = solana-1_9_28;

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
  solana-1_10_23 = mkSolana {
    version = "1.10.23";
    githubSha256 = "sha256-LR18TyJIwGcNP+CSyVzm9InlkxmnwgNd2sFE05VD99k=";
    cargoHashes = {
      solana-full = "sha256-CG/CxLTGqe8qhu2YttTwRU1V3PJ2+mgy1NhZa8rmjBI=";
      solana-basic = "sha256-ajoCGS4gZVEBjHzf4JWrh/RSP1OgvMUPF/tcYgYavoY=";
    };
  };
  solana-1_10_39 = mkSolana {
    version = "1.10.39";
    githubSha256 = "sha256-3zcIIcgGcMuQz46e7lxBiOcIBi37VHQYArp6xCKGJa4=";
    cargoHashes = {
      solana-full = "sha256-NGs85HcL0Zrhoomzeioj3ouBQb0gHm0a1xuskS/fG50=";
      solana-basic = "sha256-qRePqTUYdnD7EQOkoZRU/qfw8euxTjAzrooYjMB3qXQ=";
    };
  };
  solana-1_10 = solana-1_10_39;

  solana-1_11_10 = mkSolana {
    version = "1.11.10";
    githubSha256 = "sha256-mHPbI0MxL1vO++iVcuvFjroLXYX+gJTAtslRhCQvVSw=";
    cargoHashes = {
      solana-full = "sha256-k8X0QK++g0cly79hVHlxl8zL0oZy0fYwumFTw45dADc=";
      solana-basic = "sha256-8JBLJvYA3NA2WYSodwA5jvQwvs1ZzEFMomVpvs6X3uE=";
    };
  };
  solana-1_11 = solana-1_11_10;

  solana-1_13_05 = mkSolana {
    version = "1.13.5";
    githubSha256 = "sha256-O/vy4750vM3Gk2uc2qslmPOSu4dIes/3i6CC48v072E=";
    cargoHashes = {
      solana-full = "sha256-1HXQv1/i7CT0aAwFVQq3d3LnreOxp0hvDAJmBZ4o7gU=";
      solana-basic = "sha256-Tj5gZ4/9NnInRMcq4l+8WIUzlBreAU8NpKUx13IsvXA=";
    };
  };
  solana-1_13 = solana-1_13_05;

  solana = solana-1_10;
}
