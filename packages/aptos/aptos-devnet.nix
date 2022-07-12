{ callPackage, fetchFromGitHub, cargo-hakari }:


let
  buildAptos = callPackage ./aptos.nix {
    inherit cargo-hakari;
  };
  buildAptosDevnet = { pname, cargoSha256, buildAndTestSubdir ? null }:
    buildAptos rec {
      inherit pname;
      # https://github.com/movingco/aptos-core/tree/devnet-for-nix
      version = "a0ba71f4f02d403ce3222bc9a87aa3f2df95f49b";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "aptos-core";
        rev = version;
        sha256 = "sha256-1gj5jZ59cjeJocUaloJ1aH2c6iQAKPi3hzRaLruakJk=";
      };

      inherit cargoSha256 buildAndTestSubdir;
    };
in
{
  cli = buildAptosDevnet {
    pname = "aptos-cli";
    cargoSha256 = "sha256-lzu9MtgPm0+jd9Q60MwBPOcYvo2jAPTPLz6pAglK0KI=";
    buildAndTestSubdir = "crates/aptos";
  };

  full = buildAptosDevnet {
    pname = "aptos";
    cargoSha256 = "sha256-awAZECBHFfKNVwvPON0moglSy6MGT/tSH1cF8K4vwgI=";
  };
}
