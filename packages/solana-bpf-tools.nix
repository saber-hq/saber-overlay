{ pkgs, ... }:

with pkgs;
stdenv.mkDerivation rec {
  name = "solana-bpf-tools-rust";
  version = "1.23";
  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = "rust";
    rev = "bpf-tools-v${version}";
    sha256 = "sha256-vhx0+FuzqdJ4y8vhw3wN0u0YKaCAePD+7pyn/UcshQQ=";
  };

  nativeBuildInputs = [ python ninja ];

  buildPhase = ''
    ./build.sh
  '';

  installPhase = ''
    unameOut="$(uname -s)"
    case "$\{unameOut}" in
        Darwin*)
            EXE_SUFFIX=
            HOST_TRIPLE=x86_64-apple-darwin
            ARTIFACT=solana-bpf-tools-osx.tar.bz2;;
        MINGW*)
            EXE_SUFFIX=.exe
            HOST_TRIPLE=x86_64-pc-windows-msvc
            ARTIFACT=solana-bpf-tools-windows.tar.bz2;;
        Linux* | *)
            EXE_SUFFIX=
            HOST_TRIPLE=x86_64-unknown-linux-gnu
            ARTIFACT=solana-bpf-tools-linux.tar.bz2
    esac

    mkdir -p $out/rust/lib/rustlib/
    cp -R "build/$\{HOST_TRIPLE}/stage1/bin" $out/rust/
    cp -R "build/$\{HOST_TRIPLE}/stage1/lib/rustlib/$\{HOST_TRIPLE}" $out/rust/lib/rustlib/
    cp -R "build/$\{HOST_TRIPLE}/stage1/lib/rustlib/bpfel-unknown-unknown" $out/rust/lib/rustlib/
  '';
}

