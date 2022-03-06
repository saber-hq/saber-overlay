{ nixpkgs, flake-utils, supportedSystems, systemOutputs }:
{
# Override packages
overrides ? { },
# Setup overrides from packages
setupOverrides ? { pkgs }: { },
# Set up build tools
setupBuildTools ? { pkgs }:
  {
    anchor = pkgs.anchor;
    solana = pkgs.solana-basic;
  } // overrides // (setupOverrides { inherit pkgs; }) }:
flake-utils.lib.eachSystem supportedSystems (system:
  let
    pkgs = import nixpkgs { inherit system; }
      // systemOutputs.packages.${system};

    buildTools = setupBuildTools { inherit pkgs; };
    tool-anchor = buildTools.anchor;
    tool-solana = buildTools.solana;

    env-anchor-idls = with pkgs;
      buildEnv {
        name = "env-anchor-idls";
        description = "Environment used for generating Anchor IDLs.";

        paths = [
          tool-anchor

          # nodejs tools
          nodejs
          yarn
          python3

          # Used for generating Anchor IDLs.
          gnused
          jq
        ];
      };

    env-anchor-build = with pkgs;
      buildEnv {
        name = "env-anchor-build";
        description = "Environment used for building Anchor packages.";

        paths = [
          env-anchor-idls

          # Rust build tools
          tool-solana
          saber-rust-build-common
        ];
      };

    env-release-crates = with pkgs;
      buildEnv {
        name = "env-release-crates";
        description = "Environment used for releasing Crates.";
        paths = [ rust-stable cargo-workspaces ] ++ rust-build-common;
      };

    env-release-npm = with pkgs;
      buildEnv {
        name = "env-release-npm";
        description = "Environment used for releasing NPM packages.";
        paths = [ env-anchor-idls ];
      };

    devShell = with pkgs;
      stdenvNoCC.mkDerivation {
        name = "saber-devenv";
        buildInputs = [ ci rustup gh cargo-deps cargo-readme nixfmt ];
      };
  in {
    inherit devShell;
    packages = {
      inherit ci env-anchor-build env-release-crates env-release-npm;
      rust = rust-stable;
    };
  })
