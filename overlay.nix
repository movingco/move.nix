self: super: rec {
  cargo-hakari = import ./packages/cargo-hakari.nix {
    inherit (super) fetchCrate rustPlatform;
  };

  aptos-devenv = import ./packages/aptos-devenv.nix {
    pkgs = super;
    inherit cargo-hakari;
  };
}
