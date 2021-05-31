{ solana-bpf-tools, fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "solana-bpf-sdk";
  version = "1.6.10";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U75eUp2ZFu/Fyg2/yTk1W3FFMr0yWfOloZFhf9fLxtE=";
  };

  buildInputs = [ solana-bpf-tools ];

  installPhase = ''
    mv sdk/bpf/ $out
    mkdir -p $out/dependencies
    ln -s ${solana-bpf-tools} $out/dependencies/bpf-tools
  '';
}
