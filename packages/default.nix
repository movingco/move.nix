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

  sui = sui-devnet.full;
  sui-cli = sui-devnet.cli;
  sui-gateway = sui-devnet.gateway;

  aptos-devenv = pkgs.callPackage ./aptos-devenv.nix {
    inherit cargo-hakari;
  };

  move-ts = pkgs.callPackage ./move-ts.nix { };
  move-ts-sui = move-ts.override { buildFeatures = [ "address20" ]; };
  move-ts-aptos = move-ts.override { buildFeatures = [ "address32" ]; };


  z3 = pkgs.callPackage ./z3.nix { };

  move-cli = pkgs.callPackage ./move-cli.nix { };
  move-cli-address20 = move-cli.override { buildFeatures = [ "address20" ]; };
  move-cli-address32 = pkgs.callPackage ./move-cli-wrapper.nix {
    inherit z3;
    name = "move-cli-address32";
    move-cli = move-cli.override { buildFeatures = [ "address32" ]; };
  };
}
