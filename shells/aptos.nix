# This shell can be used for Aptos projects.
{ pkgs }:
with pkgs;
let
  installProver = !stdenv.isi686;
in
stdenv.mkDerivation {
  name = "devshell-aptos";

  # See: <https://github.com/move-language/move/blob/2dabc08cb115a2385d3844b681917dd3129a30fe/scripts/dev_setup.sh>
  buildInputs = [
    nixpkgs-fmt
    move-cli-address32
    move-ts-aptos
    aptos

    # Git is needed to be able to clone packages
    git
  ];
}
