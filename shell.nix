{ pkgs }:

with pkgs;
mkShell {
  packages = [ nixpkgs-fmt cargo-hakari ];
}
