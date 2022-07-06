{ pkgs }:

with pkgs;
mkShell {
  packages = [
    nixpkgs-fmt
    cargo-hakari
    # aptos-cli
    move-cli-aptos
  ];
}
