{ lib, validatorOnly ? false, rustPlatform, clang, llvm, pkgconfig, libudev
, openssl, zlib, libclang, fetchFromGitHub, stdenv, darwinPackages, protobuf
, rustfmt }:

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
    # "solana-stake-monitor"
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
  version = "1.7.14";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-oEGYrAdSvS2W2AjUNOUHK4IeSzGWWDzQTmE2zkDFQVM=";
  };

  # partly inspired by https://github.com/obsidiansystems/solana-bridges/blob/develop/default.nix#L29
  cargoSha256 = "sha256-oZGynLAa7Sb0QG+3qtu1mxwiKVq3uN+RJJUc8IFmjeU=";
  verifyCargoDeps = true;

  cargoBuildFlags = builtins.map (name: "--bin=${name}") solanaPkgs;

  # weird errors. see https://github.com/NixOS/nixpkgs/issues/52447#issuecomment-852079285
  LIBCLANG_PATH = "${libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS =
    "-isystem ${libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  nativeBuildInputs = [ clang llvm pkgconfig protobuf rustfmt ];
  buildInputs =
    ([ openssl zlib libclang ] ++ (lib.optionals stdenv.isLinux [ libudev ]))
    ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
