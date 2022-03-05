{ pkgs, rustStable, darwinPackages }:
let
  mkSolana = (args:
    import ./solana-packages.nix {
      inherit pkgs rustStable darwinPackages;
      inherit (args) version githubSha256 cargoHashes;
    });
in rec {
  solana-1_7_14 = mkSolana {
    version = "1.7.14";
    githubSha256 = "sha256-oEGYrAdSvS2W2AjUNOUHK4IeSzGWWDzQTmE2zkDFQVM=";
    cargoHashes = {
      solana-full = "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU=";
      solana-basic = "sha256-qsY1/xk90gQ3fQtGwdkPGDWYAHR3CttJ7r692e1Mpno=";
    };
  };
  solana-1_8_12 = mkSolana {
    version = "1.8.12";
    githubSha256 = "sha256-aY1mYxQ9NZtb+TuZrLNUCm2IS23WygY7vcmgPnSRa3w=";
    cargoHashes = {
      solana-full = "sha256-vuqpC3ts92RPpQ/vy/OBDW0heL/3EfhAZhddsW5A2tA=";
      solana-basic = "sha256-h6uqKCTrWJz/83HP5VhMShvcZQn6IVUaRNpnbGUnXTk=";
    };
  };
  solana = solana-1_8_12;
}
