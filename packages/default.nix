{ pkgs }:
with pkgs;
rec {
  sui-devnet = callPackage ./sui/sui-devnet.nix { };

  move-ts = callPackage ./move-ts.nix { };
  move-ts-sui = move-ts.override { buildFeatures = [ "address20" ]; };
  move-ts-aptos = move-ts.override { buildFeatures = [ "address32" ]; };
  z3 = z3_4_11;
  wrapWithProver = callPackage ./wrapWithProver.nix { };
  move-to-ts = callPackage ./move-to-ts.nix { };

  inherit (callPackages ./aptos {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
  }) aptos aptos-node aptos-tools aptos-full;

  inherit (callPackages ./sui {
    inherit (darwin.apple_sdk.frameworks) DiskArbitration Foundation;
  }) sui sui-gateway sui-node sui-tools sui-full;

  inherit (callPackages ./move-cli.nix {
    inherit (darwin.apple_sdk.frameworks) IOKit Security CoreFoundation AppKit System;
  }) move-cli move-cli-address20 move-cli-address32;

  env-rust = callPackage ./envs/rust.nix { };
  env-aptos-dev = callPackage ./envs/aptos-dev.nix { };
  env-sui-dev = callPackage ./envs/sui-dev.nix { };
  env-move = callPackage ./envs/move.nix { };
}
