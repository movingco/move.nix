{ pkgs }:

with pkgs;
mkShell {
  packages = [
    nixpkgs-fmt
    cargo-hakari
    aptos
    move-cli-aptos
  ];
}
