# Useful for when dealing with a Rust crate.
{ pkgs, cargo-hakari, cargo-workspaces }:
with pkgs;
mkShell {
  name = "rust-devenv";
  buildInputs = [
    move-cli-address32
    git

    pkg-config
    openssl

    rustup
    rust-analyzer
    cargo-expand
    cargo-hakari
    cargo-outdated
    cargo-readme
    cargo-workspaces
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );
}
