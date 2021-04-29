{ pkgs, validatorOnly ? false }:

with pkgs;
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
  version = "v1.6.1";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = pname;
    rev = version;
    sha256 = "0pnrx1ama35yplfrbxy017bafya1yl329902dm3zvghjrz9pka04";
  };

  # partly inspired by https://github.com/obsidiansystems/solana-bridges/blob/develop/default.nix#L29
  cargoSha256 = "1xliv17p3nbsd6cbpl6df457fc7m7cj553hyp6a35zgj47s3n3i0";
  verifyCargoDeps = true;

  cargoBuildFlags = builtins.map (name: "--bin=${name}") solanaPkgs;

  LIBCLANG_PATH = "${llvmPackages_12.libclang}/lib";
  nativeBuildInputs = [ llvmPackages_12.clang llvmPackages_12.llvm pkgconfig ];
  buildInputs = [ libudev openssl zlib ];
  strictDeps = true;

  # this is too slow
  doCheck = false;
}
