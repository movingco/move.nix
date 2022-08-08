{ callPackage, fetchFromGitHub }:

let
  buildAptos = callPackage ./aptos.nix { };
  buildAptosDevnet = { pname, cargoSha256, buildAndTestSubdir ? null }:
    buildAptos rec {
      inherit pname;
      # https://github.com/movingco/aptos-core/tree/devnet-nix-2022-08-03
      version = "1fb4e5b73d09982cf41ce20c8533255c8f578965";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-3eXgDh+MVSDRDD++M/QMY+U4xS5Drs6u0TCTaRDBmrw=";
      };

      inherit cargoSha256 buildAndTestSubdir;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-z1Qeu4/Hn0RpXfbLjTRAxy2fuWxJjagj0o6ZDr7CAkE=";
    buildAndTestSubdir = "crates/aptos";
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-SvAG8TaIRYW0Eq9GwQaZvqdDyCfhE79wdIX9HyT0ir4=";
  };
}
