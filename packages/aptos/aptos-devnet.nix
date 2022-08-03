{ callPackage, fetchFromGitHub, cargo-hakari }:


let
  buildAptos = callPackage ./aptos.nix {
    inherit cargo-hakari;
  };
  buildAptosDevnet = { pname, cargoSha256, buildAndTestSubdir ? null }:
    buildAptos rec {
      inherit pname;
      # https://github.com/movingco/aptos-core/tree/devnet-nix-2022-08-03
      version = "2104dd2ac477fedbb180e6ef866f5ae527dee8ab";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-9Atz9eeDeD9D5V6zotpR/r5Gf298Ukc7HgEwESuIreE=";
      };

      inherit cargoSha256 buildAndTestSubdir;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-xgk41L61veaRJMAAigChrT6CytbAlVwk2nJXgTK5pBM=";
    buildAndTestSubdir = "crates/aptos";
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-eaVBwhD3bWw3bak/3mMLfJ1GbPR5J5fdwA6PyBfDmmw=";
  };
}
