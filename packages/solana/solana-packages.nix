{ pkgs, rustStable, darwinPackages, version, githubSha256, cargoHashes
, solana-bpf-tools }:
let
  mkSolana = args:
    (pkgs.callPackage ./solana.nix ({
      inherit (rustStable) rustPlatform;
      inherit pkgs;
      inherit (pkgs)
        lib pkgconfig udev openssl zlib fetchFromGitHub stdenv protobuf rustfmt
        perl;
      inherit (pkgs.llvmPackages_12) clang llvm libclang;
      inherit darwinPackages;
      inherit version githubSha256;
      inherit solana-bpf-tools;
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
}
