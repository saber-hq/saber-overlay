{ pkgs
, rustStable
, darwinPackages
, rust-1_60
}:
let
  mkSolana = (
    { rust ? rustStable, cargoOutputHashes ? { }, ... }@args:
    import ./solana-packages.nix {
      inherit pkgs rust darwinPackages cargoOutputHashes;
      inherit (args) version githubSha256;
      cargoLockFile = ./cargo/v${args.version}.Cargo.lock;
    }
  );
in
rec {
  # Don't forget to download a Cargo.lock at https://raw.githubusercontent.com/solana-labs/solana/v1.17.6/Cargo.lock

  solana-1_7_17 = mkSolana {
    version = "1.7.17";
    githubSha256 = "sha256-PSAalxB9pHFHoUfw5UvpGWqmURT/3R3jK6PdMQoiDXc=";
    rust = rust-1_60;
  };
  solana-1_7 = solana-1_7_17;

  solana-1_8_16 = mkSolana {
    version = "1.8.16";
    githubSha256 = "sha256-bU76hCsKlPCcTvEFJh95CIEzz47QlmU4mpFZXpP/erc=";
    rust = rust-1_60;
  };
  solana-1_8 = solana-1_8_16;

  solana-1_9_28 = mkSolana {
    version = "1.9.28";
    githubSha256 = "sha256-r11K/3XajpIKuqb8mBvn0ynvMx5jtTjhOTZFxb0x2no=";
  };
  solana-1_9 = solana-1_9_28;

  solana-1_10_39 = mkSolana {
    version = "1.10.39";
    githubSha256 = "sha256-3zcIIcgGcMuQz46e7lxBiOcIBi37VHQYArp6xCKGJa4=";
  };
  solana-1_10 = solana-1_10_39;

  solana-1_11_10 = mkSolana {
    version = "1.11.10";
    githubSha256 = "sha256-mHPbI0MxL1vO++iVcuvFjroLXYX+gJTAtslRhCQvVSw=";
  };
  solana-1_11 = solana-1_11_10;

  solana-1_13_5 = mkSolana {
    version = "1.13.5";
    githubSha256 = "sha256-O/vy4750vM3Gk2uc2qslmPOSu4dIes/3i6CC48v072E=";
    rust = rust-1_60;
  };
  solana-1_13 = solana-1_13_5;

  solana-1_17_6 = mkSolana {
    version = "1.17.6";
    githubSha256 = "sha256-wkzE+sb0Dqx3cJ2ie3HWr+IVNZgrTDw1FYT3tENTFJc=";
    cargoOutputHashes = {
      "crossbeam-epoch-0.9.5" = "sha256-Jf0RarsgJiXiZ+ddy0vp4jQ59J9m0k3sgXhWhCdhgws=";
    };
  };
  solana-1_17 = solana-1_17_6;

  solana = solana-1_17;
}
