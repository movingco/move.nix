# This shell can be used for both Aptos and Sui projects.
{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "devenv-move";

  buildInputs = [
    nixpkgs-fmt
    move-cli-address32
    move-ts-sui
    sui
    aptos
  ];
}
