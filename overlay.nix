self: super: {
  cargo-hakari = import ./packages/cargo-hakari.nix {
    inherit (super) fetchCrate rustPlatform;
  };
}
