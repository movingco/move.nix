{ pkgs, cargo-hakari, cargo-workspaces }:
with pkgs;
mkShell {
  name = "rust-devenv";
  buildInputs = [
    git

    pkg-config
    openssl

    rustup
    rust-analyzer
    cargo-hakari
    cargo-outdated
    cargo-readme
    cargo-workspaces
  ] ++ (
    lib.optional stdenv.isDarwin ([ libiconv ]
      ++ (with darwin.apple_sdk.frameworks; [ DiskArbitration Foundation ]))
  );

  packages = [
    cargo-expand
  ];
}
