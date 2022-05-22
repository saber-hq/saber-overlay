{ name ? "solana"
, lib
, validatorOnly ? false
, rustPlatform
, pkg-config
, udev
, openssl
, zlib
, fetchFromGitHub
, stdenv
, darwinPackages
, protobuf
, rustfmt
, cargoSha256
, version
, githubSha256
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
  ]
}:

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

  nativeBuildInputs = [ pkg-config protobuf ];
  buildInputs =
    ([ openssl zlib ] ++ (lib.optionals stdenv.isLinux [ udev ]))
    ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  meta = with lib; {
    description = "Web-Scale Blockchain for fast, secure, scalable, decentralized apps and marketplaces. ";
    homepage = "https://solana.com";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
  };
}
