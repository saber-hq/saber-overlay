# Some of this file is taken from https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/applications/blockchains/solana/default.nix
{ name ? "solana"
, lib
, validatorOnly ? false
, rustPlatform
, clang
, llvm
, pkg-config
, udev
, openssl
, zlib
, libclang
, fetchFromGitHub
, stdenv
, darwinPackages
, darwin
, libcxx
, protobuf
, rustfmt
, cargoLockFile
, version
, githubSha256
, perl
, cargoOutputHashes
, rocksdb
, # Taken from https://github.com/solana-labs/solana/blob/master/scripts/cargo-install-all.sh#L84
  solanaPkgs ? [
    "solana"
    "solana-bench-tps"
    "solana-faucet"
    "solana-gossip"
    "solana-install"
    "solana-keygen"
    "solana-ledger-tool"
    "solana-log-analyzer"
    "solana-net-shaper"
    # removed; TODO(igm): should allow different versions to specify
    # "solana-sys-tuner"
    "solana-validator"
    # "rbpf-cli"

    # Speed up net.sh deploys by excluding unused binaries
  ] ++ (lib.optionals (!validatorOnly) [
    "cargo-build-bpf"
    "cargo-test-bpf"
    "solana-dos"
    "solana-install-init"
    "solana-stake-accounts"
    "solana-test-validator"
    "solana-tokens"
    "solana-watchtower"
  ]) ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ]
}:

let
  inherit (darwin.apple_sdk_11_0) Libsystem;
  inherit (darwin.apple_sdk_11_0.frameworks) System IOKit AppKit Security;
in
rustPlatform.buildRustPackage rec {
  pname = name;
  inherit version;

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "solana";
    rev = "v${version}";
    sha256 = githubSha256;
  };

  # partly inspired by https://github.com/obsidiansystems/solana-bridges/blob/develop/default.nix#L29
  cargoLock = {
    lockFile = cargoLockFile;
    outputHashes = cargoOutputHashes;
  };

  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;

  nativeBuildInputs = [ clang llvm pkg-config protobuf rustfmt perl ];
  buildInputs =
    [
      openssl
      rustPlatform.bindgenHook
      zlib
      libclang
    ]
    ++ lib.optionals stdenv.isLinux [ udev ]
    ++ lib.optionals stdenv.isDarwin [
      libcxx
      IOKit
      Security
      AppKit
      System
      Libsystem
    ]
    ++ lib.optionals useRocksDBFromNixpkgs [ rocksdb ];
  strictDeps = true;

  postInstall = ''
    mkdir -p $out/bin/sdk/bpf
    cp -a ./sdk/bpf/* $out/bin/sdk/bpf/
  '';

  # this is too slow
  doCheck = false;

  # Used by build.rs in the rocksdb-sys crate. If we don't set these, it would
  # try to build RocksDB from source.
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  # Require this on darwin otherwise the compiler starts rambling about missing
  # cmath functions
  CPPFLAGS = lib.optionals stdenv.isDarwin "-isystem ${lib.getDev libcxx}/include/c++/v1";
  LDFLAGS = lib.optionals stdenv.isDarwin "-L${lib.getLib libcxx}/lib";

  # If set, always finds OpenSSL in the system, even if the vendored feature is enabled.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    homepage = "https://solana.com/";
    description =
      "Solana is a decentralized blockchain built to enable scalable, user-friendly apps for the world.";
    platforms = platforms.unix ++ platforms.darwin;
  };
}
