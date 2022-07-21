{ callPackage, fetchFromGitHub, cargo-hakari }:


let
  buildAptos = callPackage ./aptos.nix {
    inherit cargo-hakari;
  };
  buildAptosDevnet = { pname, cargoSha256, buildAndTestSubdir ? null }:
    buildAptos rec {
      inherit pname;
      # https://github.com/movingco/aptos-core/tree/devnet-for-nix-2
      version = "58d09aa9434936b108e9ba562fe52d34f58e2023";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-9Atz9deDeD9D5V6zotpR/r5Gf298Ukc7HgEwESuIreE=";
      };

      inherit cargoSha256 buildAndTestSubdir;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-xgk41K61veaRJMAAigChrT6CytbAlVwk2nJXgTK5pBM=";
    buildAndTestSubdir = "crates/aptos";
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-eaVBwhD3aWw3bak/3mMLfJ1GbPR5J5fdwA6PyBfDmmw=";
  };

  af-cli = buildAptosDevnet {
    pname = "af-cli";
    cargoSha256 = "sha256-/TYeR0N4tcd16Yy1ulgx7rT03QjrKXUWwwPCrrxeUlk=";
    buildAndTestSubdir = "aptos-move/af-cli";
  };
}
