{ pkgs }:
with pkgs;
rec {
  cargo-hakari = pkgs.callPackage ./cargo-hakari.nix { };
  sui-devnet = pkgs.callPackage ./sui/sui-devnet.nix { };
  aptos-devnet = pkgs.callPackage ./aptos/aptos-devnet.nix { };

  sui = sui-devnet.full;
  sui-cli = sui-devnet.cli;
  sui-gateway = sui-devnet.gateway;

  move-ts = pkgs.callPackage ./move-ts.nix { };
  move-ts-sui = move-ts.override { buildFeatures = [ "address20" ]; };
  move-ts-aptos = move-ts.override { buildFeatures = [ "address32" ]; };
  z3 = pkgs.callPackage ./z3.nix { };
  wrapWithProver = pkgs.callPackage ./wrapWithProver.nix { };
  move-to-ts = pkgs.callPackage ./move-to-ts.nix { };

  inherit (callPackages ./move-cli.nix {
    inherit (darwin.apple_sdk.frameworks) IOKit Security CoreFoundation AppKit System;
  }) move-cli move-cli-address20 move-cli-address32;

  aptos-cli = aptos-devnet.cli;
  aptos = aptos-devnet.full;

  cargo-workspaces = pkgs.callPackage ./cargo-workspaces.nix { };

  env-rust = pkgs.callPackage ./envs/rust.nix { };
  env-aptos-dev = pkgs.callPackage ./envs/aptos-dev.nix { };
  env-move = pkgs.callPackage ./envs/move.nix { };
}
