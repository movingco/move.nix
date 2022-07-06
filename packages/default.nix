{ pkgs }:
rec {
  cargo-hakari = import ./cargo-hakari.nix {
    inherit (pkgs) fetchCrate rustPlatform;
  };

  aptos-devenv = import ./aptos-devenv.nix {
    inherit pkgs;
    inherit cargo-hakari;
  };

  aptos = import ./aptos.nix {
    inherit cargo-hakari;
    inherit (pkgs) lib rustPlatform fetchFromGitHub libclang clang
      pkg-config rustc cargo rustfmt rocksdb
      postgresql openssl stdenv darwin libiconv;
  };

  move-cli = pkgs.callPackage ./move-cli.nix {
    inherit (pkgs) lib pkgconfig openssl zlib fetchFromGitHub rustPlatform;
    darwinPackages = pkgs.lib.optionals pkgs.stdenv.isDarwin
      (with pkgs.darwin.apple_sdk.frameworks;
      ([ IOKit Security CoreFoundation AppKit ]
        ++ (pkgs.lib.optionals pkgs.stdenv.isAarch64 [ System ])));
  };

  move-cli-sui = move-cli.override { buildFeatures = [ "address20" ]; };

  move-cli-aptos = move-cli.override { buildFeatures = [ "address32" ]; };
}
