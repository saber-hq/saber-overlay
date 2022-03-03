{ name ? "solana", pkgs, lib, validatorOnly ? false, rustPlatform, clang, llvm
, pkgconfig, udev, openssl, zlib, libclang, fetchFromGitHub, stdenv
, darwinPackages, protobuf, rustfmt, cargoSha256, version, githubSha256, perl
, patches ? [ ],

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

let
  bpfTools = stdenv.mkDerivation {
    name = "bpf-tools";
    version = "v1.23";
    src = builtins.fetchurl (if stdenv.isDarwin then {
      sha256 = "1n538g50f7jscigrlhyfpd554jrha03bn80j7ly2kln87rj2a77k";
      url =
        "https://github.com/solana-labs/bpf-tools/releases/download/v1.23/solana-bpf-tools-osx.tar.bz2";
    } else {
      sha256 = "0qp297s5mmv8r5xac92si9mq3lf6gigsm8npvp2rpnx0lp9byj29";
      url =
        "https://github.com/solana-labs/bpf-tools/releases/download/v1.23/solana-bpf-tools-linux.tar.bz2";
    });
    sourceRoot = ".";
    dontBuild = true;
    installPhase = ''
      mkdir $out
      cp -R . $out/
    '';
  };
in rustPlatform.buildRustPackage rec {
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

  nativeBuildInputs = [ clang llvm pkgconfig protobuf rustfmt perl ];
  buildInputs =
    ([ openssl zlib libclang ] ++ (lib.optionals stdenv.isLinux [ udev ]))
    ++ darwinPackages;
  strictDeps = true;

  # this is too slow
  doCheck = false;

  # BPF SDK. See https://github.com/cideM/solana-nix/pull/4/files.
  inherit patches;

  preInstall = ''
    mkdir -p $out/bin/sdk/bpf/dependencies
  '';

  postInstall = ''
    ${pkgs.rsync}/bin/rsync -a ${src}/sdk $out/bin/
    ln -s ${bpfTools} $out/bin/sdk/bpf/dependencies/bpf-tools
  '';

  meta = with lib; {
    homepage = "https://solana.com/";
    description =
      "Solana is a decentralized blockchain built to enable scalable, user-friendly apps for the world.";
    platforms = platforms.unix ++ platforms.darwin;
  };
}
