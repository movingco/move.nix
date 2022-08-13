{
  description = "The Moving Company flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = import ./overlay.nix;
      systems = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
          devShell = import ./shell.nix { inherit pkgs; };
        in
        {
          packages = {
            inherit (pkgs) cargo-hakari
              # aptos
              aptos
              aptos-cli
              aptos-devenv
              move-ts-aptos
              move-cli-aptos
              # sui
              sui
              sui-cli
              sui-gateway
              move-cli-sui
              move-ts-sui
              # move
              move-cli;
          };
          devShells = {
            default = devShell;
            aptos = import ./shells/aptos.nix { inherit pkgs; };
            sui = import ./shells/sui.nix { inherit pkgs; };
          };
        });
    in
    systems // {
      overlays.default = overlay;
      templates.aptos = {
        path = ./templates/aptos;
        description = "A simple Nix Flake for developing in Aptos Move.";
      };
    };
}
