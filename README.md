# move.nix

A Nix Flake for the Move ecosystem.

## Usage

You can add the Moving Company's Cachix binary cache like so:

```bash
cachix use m
```

## Installing Aptos

Aptos is not yet packaged in this repo due to Nix's Cargo integration not being able to have multiple versions of the same dependency. However, you can still install it by loading the libraries into the environment. Run the following commands:

```bash
nix develop github:movingco/move.nix#aptos-devenv
cargo install --git https://github.com/aptos-labs/aptos-core.git aptos --branch devnet
```

## License

Apache 2.0
