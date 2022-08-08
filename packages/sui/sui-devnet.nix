{ callPackage, fetchFromGitHub, cargo-hakari }:

let
  buildSui = callPackage ./sui.nix { };
  buildSuiDevnet =
    { pname
    , cargoSha256
    , buildAndTestSubdir ? null
    , cargoBuildFlags ? [ ]
    }:
    buildSui rec {
      inherit pname;
      version = "dd371d9831f746c6ade432c052df16c1e45a4e8f";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "sui";
        rev = version;
        sha256 = "sha256-6MGey+v4JTNbdKFOCBtdlYmyFvq7Lmos20ky5uOhfKY=";
      };

      inherit cargoSha256 buildAndTestSubdir cargoBuildFlags;
    };
in
{
  full = buildSuiDevnet {
    pname = "sui-full";
    cargoSha256 = "sha256-41NGUdYjLQ3NumUgM1qY2+PjALzHKRLeLMc3ZwLgiFs=";
  };

  cli = buildSuiDevnet {
    pname = "sui";
    cargoSha256 = "sha256-41NGUdYjLQ3NumUgM1qY2+PjALzHKRLeLMc3ZwLgiFs=";
    buildAndTestSubdir = "crates/sui";
    cargoBuildFlags = [ "--package" "sui" ];
  };

  gateway = buildSuiDevnet {
    pname = "sui-gateway";
    cargoSha256 = "sha256-Opv002a1ifDz/SXIv7N4CLCpLkzreDiJHDBQGkpKCW0=";
    buildAndTestSubdir = "crates/sui-gateway";
    cargoBuildFlags = [ "--package" "sui-gateway" ];
  };
}
