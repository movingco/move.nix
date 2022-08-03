# move.nix

A Nix Flake for the Move ecosystem.

## Usage

You can add the Moving Company's Cachix binary cache like so:

```bash
cachix use m
```

## Templates

To create a new Aptos Move project, run the following command:

```bash
nix flake init --template github:movingco/move.nix#aptos
```

### Example

If you want a shell with Aptos installed, you may run the following:

```bash
nix develop github:movingco/move.nix#aptos
```

## Notes

When building Aptos locally, you may encounter an error around a lock. To get around this,
run the following command before any Aptos build:

```
sudo rm /tmp/*.lock
```

## License

Apache 2.0
