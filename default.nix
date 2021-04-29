_: pkgs: {
  solana = import ./solana.nix { inherit pkgs; };
  solana-validator-only = import ./solana.nix {
    inherit pkgs;
    validatorOnly = true;
  };

  solana-rust-bpf = with pkgs;
    stdenv.mkDerivation {
      name = "solana-rust-bpf";
      src = fetchTarball {
        name = "solana-rust-bpf-linux";
        url =
          "https://github.com/solana-labs/rust-bpf-builder/releases/download/v0.2.5/solana-rust-bpf-linux.tar.bz2";
        sha256 = "0bhj2cdzrd77yg2a46gd9s7jr32jzsvg7bijq0v214kkyjd3a3f4";
      };
      nativeBuildInputs = [ autoPatchelfHook openssl stdenv.cc.cc.lib ];
      installPhase = ''
        cp -R $src $out
      '';
    };

  solana-llvm = with pkgs;
    stdenv.mkDerivation {
      name = "solana-llvm";
      src = fetchTarball {
        url =
          "https://github.com/solana-labs/llvm-builder/releases/download/v0.0.15/solana-llvm-linux.tar.bz2";
        sha256 = "09bfj3jg97d2xh9c036xynff0fpg648vhg4sva0sabi6rpzp2c8r";
      };
      nativeBuildInputs = [ autoPatchelfHook stdenv.cc.cc.lib ];
      installPhase = ''
        cp -R $src $out
      '';
    };

  xargo = with pkgs;
    rustPlatform.buildRustPackage rec {
      pname = "xargo";

      version = "v0.3.22";

      src = fetchFromGitHub {
        owner = "japaric";
        repo = pname;
        rev = "b7cec9d3dc3720f0b7964f4b6e3a1878f94e4c07";
        sha256 = "0m1dg7vwmmlpqp20p219gsm7zbnnii6lik6hc2vvfsdmnygf271l";
      };

      cargoSha256 = "14q1p6jc806h24qv9shx0qn8njfbh4c7ymbjkv8fnl7aal2lj3jw";
      verifyCargoDeps = true;

      # TODO: allow tests to run in debug in nixpkgs
      # error[E0554]: `#![feature]` may not be used on the stable release channel
      #  --> tests/smoke.rs:3:1
      # buildType = "debug";
      doCheck = false;
      strictDeps = true;
      buildInputs = [ makeWrapper ];

      postInstall = ''
        wrapProgram $out/bin/xargo \
        --set-default RUST_BACKTRACE FULL \
      '';
    };

  rust-bpf-sysroot = with pkgs;
    fetchFromGitHub {
      owner = "solana-labs";
      repo = "rust-bpf-sysroot";
      rev = "b4dc90e3ee8a88f197876bc76149add1de7fec25"; # branch v0.12
      sha256 = "1jiw61bdxb10s2xnf9lcw8aqra35vq2a95kk01kz72kqm63rijy8";
      fetchSubmodules = true;
    };
}
