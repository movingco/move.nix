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
            inherit (pkgs) cargo-hakari aptos-devenv aptos aptos-cli
              af-cli move-cli move-cli-sui move-cli-aptos;
          };
          devShells.default = devShell;
        });
    in
    systems // {
      overlays.default = overlay;
    };
}
