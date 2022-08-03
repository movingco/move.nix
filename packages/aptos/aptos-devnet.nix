{ callPackage, fetchFromGitHub, cargo-hakari }:


let
  buildAptos = callPackage ./aptos.nix {
    inherit cargo-hakari;
  };
  buildAptosDevnet = { pname, cargoSha256, buildAndTestSubdir ? null }:
    buildAptos rec {
      inherit pname;
      # https://github.com/movingco/aptos-core/tree/devnet-nix-2022-08-03
      version = "1fb4e5b73d09982cf41ce20c8533255c8f578965";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-IMU2BA+N187DR23nIoQntZklVuh30yPMN2p9KjLO8wE=";
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
