{ pkgs, rustStable, darwinPackages, version, githubSha256, cargoHashes }:
let
  mkSolana = args:
    (pkgs.callPackage ./solana.nix ({
      inherit (rustStable) rustPlatform;
      inherit (pkgs)
        lib pkgconfig libudev openssl zlib fetchFromGitHub stdenv protobuf
        rustfmt perl;
      inherit (pkgs.llvmPackages_12) clang llvm libclang;
      inherit darwinPackages;
      inherit version githubSha256;
    } // args));
  mkSolanaPackage = name: cargoSha256:
    mkSolana {
      inherit name cargoSha256;
      solanaPkgs = [ name ];
    };
in {
  # This is the ideal package to use.
  # However, it does not build on Darwin.
  solana-full = mkSolana { cargoSha256 = cargoHashes.solana-full; };

  solana-basic = mkSolana {
    name = "solana-basic";
    solanaPkgs = [
      "cargo-build-bpf"
      "cargo-test-bpf"
      "solana"
      "solana-install"
      "solana-install-init"
      "solana-keygen"
      "solana-faucet"
      "solana-stake-accounts"
      "solana-tokens"
      # solana-test-validator fails with System.framework not found error
    ];
    cargoSha256 = cargoHashes.solana-basic;
  };

  solana-cli = mkSolana {
    name = "solana-cli";
    solanaPkgs = [ "solana" ];
    cargoSha256 = cargoHashes.solana-cli;
  };
  solana-keygen = mkSolanaPackage "solana-keygen" cargoHashes.solana-keygen;
  solana-install = mkSolana {
    name = "solana-install";
    solanaPkgs = [ "solana-install" "solana-install-init" ];
    cargoSha256 = cargoHashes.solana-install;
  };
}
