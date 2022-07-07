{ pkgs }:
rec {
  cargo-hakari = pkgs.callPackage ./cargo-hakari.nix { };

  aptos-devenv = pkgs.callPackage ./aptos-devenv.nix {
    inherit cargo-hakari;
  };

  aptos = pkgs.callPackage ./aptos/full.nix {
    inherit cargo-hakari;
  };

  aptos-cli = pkgs.callPackage ./aptos/cli.nix {
    inherit cargo-hakari;
  };

  move-cli = pkgs.callPackage ./move-cli.nix { };

  move-cli-sui = move-cli.override { buildFeatures = [ "address20" ]; };

  move-cli-aptos = move-cli.override { buildFeatures = [ "address32" ]; };
}
