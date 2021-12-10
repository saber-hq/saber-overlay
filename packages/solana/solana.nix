{ name ? "solana", lib, validatorOnly ? false, rustPlatform, clang, llvm
, pkgconfig, libudev, openssl, zlib, libclang, fetchFromGitHub, stdenv
, darwinPackages, protobuf, rustfmt, cargoSha256, version, githubSha256,

# Taken from https://github.com/solana-labs/solana/blob/master/scripts/cargo-install-all.sh#L84
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
  "solana-sys-tuner"
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
] }:

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
  inherit cargoSha256;
  verifyCargoDeps = true;

  cargoBuildFlags = builtins.map (n: "--bin=${n}") solanaPkgs;

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
