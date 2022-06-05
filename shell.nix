{ pkgs }:

with pkgs;
mkShell {
  packages = [ nixpkgs-fmt ];
}
