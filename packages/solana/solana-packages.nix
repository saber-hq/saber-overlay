{ pkgs
, rust
, darwinPackages
, version
, githubSha256
, cargoLockFile
, cargoOutputHashes
}:
let
  mkSolana = args:
    (pkgs.callPackage ./solana.nix ({
      inherit (rust) rustPlatform;
      inherit (pkgs)
        lib pkg-config udev openssl zlib fetchFromGitHub stdenv protobuf rustfmt
        perl;
      inherit (pkgs.llvmPackages_12) clang llvm libclang;
      inherit darwinPackages;
      inherit version githubSha256 cargoLockFile cargoOutputHashes useRocksDBFromNixpkgs;
    } // args));
in
{
  # This is the ideal package to use.
  # However, it does not build on Darwin.
  solana-full = mkSolana { };

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
  };
}
