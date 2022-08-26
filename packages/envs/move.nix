# This shell can be used for both Aptos and Sui projects.
{ mkShell
, move-cli-address32
, move-ts-aptos
, nixpkgs-fmt
, sui
, aptos
}:
mkShell {
  name = "env-move";
  buildInputs = [
    nixpkgs-fmt
    move-cli-address32
    move-ts-aptos
    sui
    aptos
  ];
}
