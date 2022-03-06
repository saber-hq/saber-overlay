{ nixpkgs, flake-utils, supportedSystems, systemOutputs }:
{
# Override packages
buildToolOverrides ? { },
# Setup overrides from packages
setupBuildToolOverrides ? { pkgs }: { },
# Set up build tools
setupBuildTools ? { pkgs }:
  {
    anchor = pkgs.anchor;
    solana = pkgs.solana-basic;
  } // buildToolOverrides // (setupBuildToolOverrides { inherit pkgs; }) }:
flake-utils.lib.eachSystem supportedSystems (system:
  let
    pkgs = import nixpkgs { inherit system; }
      // systemOutputs.packages.${system};

    buildTools = setupBuildTools { inherit pkgs; };
    tool-anchor = buildTools.anchor;
    tool-solana = buildTools.solana;

    env-anchor-idls = with pkgs;
      stdenvNoCC.mkDerivation {
        name = "saber-env-anchor-idls";
        meta.description = "Environment used for generating Anchor IDLs.";

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
      stdenvNoCC.mkDerivation {
        name = "saber-env-anchor-build";
        meta.description = "Environment used for building Anchor packages.";

        buildInputs = [
          env-anchor-idls

          # Rust build tools
          tool-solana
          saber-rust-build-common
        ];
      };

    env-release-crates = with pkgs;
      buildEnv {
        name = "saber-env-release-crates";
        meta.description = "Environment used for releasing Crates.";
        paths = [ rust-stable cargo-workspaces ] ++ rust-build-common;
      };

    env-release-npm = with pkgs;
      buildEnv {
        name = "saber-env-release-npm";
        meta.description = "Environment used for releasing NPM packages.";
        paths = [ env-anchor-idls ];
      };

    devShell = with pkgs;
      stdenvNoCC.mkDerivation {
        name = "saber-env-devshell";
        buildInputs =
          [ env-anchor-build env-release-crates saber-dev-utilities ];
      };
  in {
    inherit devShell;
    packages = {
      inherit env-anchor-idls env-anchor-build env-release-crates
        env-release-npm;
      rust = rust-stable;

      anchor = tool-anchor;
      solana = tool-solana;
    };
  })
