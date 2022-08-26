# This shell can be used for Aptos projects.
{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "devshell-aptos";

  buildInputs = [
    nixpkgs-fmt
    move-cli-address32
    move-ts-aptos
    aptos

    # Git is needed to be able to clone packages
    git
  ];
}
