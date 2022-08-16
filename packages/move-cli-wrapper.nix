{ name
, move-cli
, stdenv
, z3
, icu
, boogie
, dotnet-sdk
, symlinkJoin
, makeWrapper
}:
let
  installProver = !stdenv.isi686;
in
if installProver then
  symlinkJoin
  {
    inherit name;
    paths = [
      move-cli
      z3
      icu
      boogie
      dotnet-sdk
    ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/move \
        --set Z3_EXE ${z3}/bin/z3 \
        --set DOTNET_ROOT ${dotnet-sdk} \
        --set LD_LIBRARY_PATH ${icu}/lib \
        --set BOOGIE_EXE ${boogie}/bin/boogie
    '';
  } else move-cli
