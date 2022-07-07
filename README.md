# move.nix

A Nix Flake for the Move ecosystem.

## Usage

You can add the Moving Company's Cachix binary cache like so:

```bash
cachix use m
```

### Example

If you want a shell with Aptos installed, you may run the following:

```bash
nix develop github:movingco/move.nix#aptos
```

## License

Apache 2.0
