{ pkgs, rustStable, darwinPackages, version ? "1.7.14"
, cargoSha256 ? "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU="
, githubSha256 ? "sha256-oEGYrAdSvS2W2AjUNOUHK4IeSzGWWDzQTmE2zkDFQVM=" }:
let
  mkSolana = args:
    (pkgs.callPackage ./solana.nix ({
      inherit (rustStable) rustPlatform;
      inherit (pkgs)
        lib pkgconfig libudev openssl zlib fetchFromGitHub stdenv protobuf
        rustfmt;
      inherit (pkgs.llvmPackages_12) clang llvm libclang;
      inherit darwinPackages;
      inherit version cargoSha256 githubSha256;
    } // args));
  mkSolanaPackage = name: cargoSha256:
    mkSolana {
      inherit name cargoSha256;
      solanaPkgs = [ name ];
    };
in {
  # This is the ideal package to use
  solana-full = mkSolana {
    cargoSha256 = "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU=";
  };

  solana-cli = mkSolana {
    name = "solana-cli";
    solanaPkgs = [ "solana" ];
    cargoSha256 = "sha256-GoLalVtKTi8Szqgc+Z8X4pYHNBGosVDDjb+QpmEwnEA=";
  };
  solana-keygen = mkSolanaPackage "solana-keygen"
    "sha256-eli0HuDOrDD+8rxJXduv30OWTE4uGCb6pScFPNob2TY=";
  solana-install = mkSolanaPackage "solana-install"
    "sha256-4K9BffQvZzLf4p7hhXZj7nGbXKqX8CpWoRSvAFcshTs=";
  solana-install-init = mkSolanaPackage "solana-install-init"
    "sha256-TSGU7ZUQdRwKWS+X7eW6iHYSrf+QJQZ6KyLDWdG1oEw=";

  cargo-build-bpf = mkSolanaPackage "cargo-build-bpf"
    "sha256-y2juHbVx36BlyJNjEieNyFKKIJ6d1yCr/J+j3vbqtJ4=";
  cargo-test-bpf = mkSolanaPackage "cargo-test-bpf"
    "sha256-nSfta+vK8pkRMoW4/XKPPB3hCmu0/xg23zW4xEKX6JA=";
}
