{ lib, validatorOnly ? false, rustPlatform, IOKit, Security, CoreFoundation
, AppKit, clang, llvm, pkgconfig, libudev, openssl, zlib, libclang
, fetchFromGitHub, stdenv, System }:

let
  # Taken from https://github.com/solana-labs/solana/blob/master/scripts/cargo-install-all.sh#L84
  solanaPkgs = [
    "solana"
    "solana-bench-exchange"
    "solana-bench-tps"
    "solana-faucet"
    "solana-gossip"
    "solana-install"
    "solana-keygen"
    "solana-ledger-tool"
    "solana-log-analyzer"
    "solana-net-shaper"
    "solana-sys-tuner"
    "solana-validator"

    # Speed up net.sh deploys by excluding unused binaries
  ] ++ (lib.optionals (validatorOnly == false) [
    "cargo-build-bpf"
    "cargo-test-bpf"
    "solana-dos"
    "solana-install-init"
    "solana-stake-accounts"
    "solana-stake-monitor"
    "solana-test-validator"
    "solana-tokens"
    "solana-watchtower"
  ]) ++ [
    # XXX: Ensure `solana-genesis` is built LAST!
    # See https://github.com/solana-labs/solana/issues/5826
    "solana-genesis"
  ];

in rustPlatform.buildRustPackage rec {
  pname = "solana";
  version = "1.6.9";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U75eUp2ZFu/Fyg2/yTk1W3FFMr0yWfOloZFhf9fLxtE=";
  };

  # partly inspired by https://github.com/obsidiansystems/solana-bridges/blob/develop/default.nix#L29
  cargoSha256 = "sha256-jZtd4zj92dblR1VARaqgm7B6i//xllUyijO8mXo8e1U=";
  verifyCargoDeps = true;

  cargoBuildFlags = builtins.map (name: "--bin=${name}") solanaPkgs;

  LIBCLANG_PATH = "${libclang}/lib";
  nativeBuildInputs = [ clang llvm pkgconfig ];
  buildInputs = ([ openssl zlib ] ++ (lib.optionals stdenv.isLinux [ libudev ]))
    ++ (
      # Fix for usb-related segmentation faults on darwin
      lib.optionals stdenv.isDarwin [ IOKit Security CoreFoundation AppKit ]);
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
