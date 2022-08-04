{ callPackage, fetchFromGitHub, cargo-hakari }:

let
  buildSui = callPackage ./sui.nix {
    inherit cargo-hakari;
  };
  buildSuiDevnet = { pname, cargoSha256, buildAndTestSubdir ? null }:
    buildSui rec {
      inherit pname;
      version = "dd371d9831f746c6ade432c052df16c1e45a4e8f";

      src = fetchFromGitHub {
        owner = "movingco";
        repo = "sui";
        rev = version;
        sha256 = "sha256-6MGey+v4JTNbdKFOCBtdlYmyFvq7Lmos20ky5uOhfKY=";
      };

      inherit cargoSha256 buildAndTestSubdir;
    };
in
{
  full = buildSuiDevnet {
    pname = "sui";
    cargoSha256 = "sha256-41NGUdYjLQ3NumUgM1qY2+PjALzHKRLeLMc3ZwLgiFs=";
  };
}
