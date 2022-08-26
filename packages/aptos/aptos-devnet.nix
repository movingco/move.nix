{ callPackage, fetchFromGitHub, symlinkJoin, wrapWithProver }:

let
  buildAptos = callPackage ./aptos.nix { };
  buildAptosDevnet =
    { pname
    , cargoSha256
    , cargoBuildFlags ? [ ]
    }:
    buildAptos rec {
      inherit pname;
      # https://github.com/aptos-labs/aptos-core/tree/devnet
      version = "e1c6a5713301ed72bf3a846ab9536d002ac801d6";

      src = fetchFromGitHub {
        owner = "aptos-labs";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-CFWX1LCsXYo+hVvHx7WtF6BhIf3fYs92Uj+ctqiB+G8=";
      };

      inherit cargoSha256 cargoBuildFlags;
    };
in
rec
{
  cli-no-prover = buildAptosDevnet {
    pname = "aptos-cli-no-prover";
    cargoSha256 = "sha256-/gVVS8iT9Bn9qH8gymvJZ4gXjleeox64cBqMU7+0sGo=";
    cargoBuildFlags = [ "--package" "aptos" ];
  };

  cli = wrapWithProver {
    name = "aptos-cli";
    bin = "aptos";
    package = cli-no-prover;
  };

  # Aptos tools other than the Aptos CLI
  tools = buildAptosDevnet {
    pname = "aptos-tools";
    cargoSha256 = "sha256-D9zEufbckNplOiDoraMm93W8VUX1zkM7pyyZW2X/+Eg=";
    cargoBuildFlags = [
      "--workspace"
      "--exclude"
      "aptos"
    ];
  };

  full = symlinkJoin {
    name = "aptos";
    paths = [ cli tools ];
  };
}
