{ pkgs }:
let
  cargo-hakari = pkgs.callPackage ./cargo-hakari.nix { };
  sui-devnet = pkgs.callPackage ./sui/sui-devnet.nix { };
  aptos-devnet = pkgs.callPackage ./aptos/aptos-devnet.nix { };
in
rec {
  inherit cargo-hakari;

  aptos = aptos-devnet.full;
  aptos-cli = aptos-devnet.cli;
  af-cli = aptos-devnet.af-cli;

  sui = sui-devnet.full;
  sui-cli = sui-devnet.cli;
  sui-gateway = sui-devnet.gateway;

  aptos-devenv = pkgs.callPackage ./aptos-devenv.nix {
    inherit cargo-hakari;
  };

  move-cli = pkgs.callPackage ./move-cli.nix { };
  move-cli-sui = move-cli.override { buildFeatures = [ "address20" ]; };
  move-cli-aptos = move-cli.override { buildFeatures = [ "address32" ]; };
}
