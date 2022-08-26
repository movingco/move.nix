# This shell can be used for Sui projects.
{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "devshell-sui";

  buildInputs = [
    nixpkgs-fmt
    move-cli-address20
    move-ts-sui
    sui

    # Git is needed to be able to clone packages
    git
  ];
}
