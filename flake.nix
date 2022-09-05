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
            inherit (pkgs)
              # common
              cargo-hakari
              cargo-workspaces
              move-to-ts
              move-cli
              z3
              # aptos
              aptos
              aptos-node
              aptos-tools
              aptos-full
              move-ts-aptos
              move-cli-address32
              # sui
              sui
              sui-node
              sui-gateway
              sui-tools
              sui-full
              move-cli-address20
              move-ts-sui
              # envs
              env-aptos-dev
              env-move
              env-rust;
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
