{ pkgs }:
let
  cargo-hakari = pkgs.callPackage ./cargo-hakari.nix { };
  sui-devnet = pkgs.callPackage ./sui/sui-devnet.nix { };
  aptos-devnet = pkgs.callPackage ./aptos/aptos-devnet.nix { };
in
rec {
  inherit cargo-hakari;

  sui = sui-devnet.full;
  sui-cli = sui-devnet.cli;
  sui-gateway = sui-devnet.gateway;

  move-ts = pkgs.callPackage ./move-ts.nix { };
  move-ts-sui = move-ts.override { buildFeatures = [ "address20" ]; };
  move-ts-aptos = move-ts.override { buildFeatures = [ "address32" ]; };

  z3 = pkgs.callPackage ./z3.nix { };

  wrapWithProver = pkgs.callPackage ./wrapWithProver.nix {
    inherit z3;
  };

  move-cli = pkgs.callPackage ./move-cli.nix { };
  move-cli-address20 = wrapWithProver {
    name = "move-cli-address20";
    bin = "move";
    package = move-cli.override { buildFeatures = [ "address20" ]; };
  };
  move-cli-address32 = wrapWithProver {
    name = "move-cli-address32";
    bin = "move";
    package = move-cli.override { buildFeatures = [ "address32" ]; };
  };

  aptos = wrapWithProver {
    name = "aptos";
    bin = "aptos";
    package = aptos-devnet.full;
  };
  aptos-cli = wrapWithProver {
    name = "aptos-cli";
    bin = "aptos";
    package = aptos-devnet.cli;
  };

  aptos-devenv = pkgs.callPackage ./aptos-devenv.nix {
    inherit cargo-hakari move-cli-address32;
  };

  rust-devenv = pkgs.callPackage ./rust-devenv.nix { };
}
