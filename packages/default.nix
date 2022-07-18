{ pkgs }:
let
  cargo-hakari = pkgs.callPackage ./cargo-hakari.nix { };

  aptos-devnet = pkgs.callPackage ./aptos/aptos-devnet.nix {
    inherit cargo-hakari;
  };
in
rec {
  inherit cargo-hakari;

  aptos = aptos-devnet.full;
  aptos-cli = aptos-devnet.cli;
  af-cli = aptos-devnet.af-cli;

  aptos-devenv = pkgs.callPackage ./aptos-devenv.nix {
    inherit cargo-hakari;
  };

  move-cli = pkgs.callPackage ./move-cli.nix { };

  move-cli-sui = move-cli.override { buildFeatures = [ "address20" ]; };

  move-cli-aptos = move-cli.override { buildFeatures = [ "address32" ]; };
}
