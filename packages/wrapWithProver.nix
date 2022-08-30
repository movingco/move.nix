{ stdenv
, z3
, icu
, boogie
, dotnet-sdk
, symlinkJoin
, makeWrapper
}:

{ package
, bin
}:

let
  installProver = !stdenv.isi686;
in
if installProver then
  symlinkJoin
  {
    name = "${package.name}-${bin}-with-move-prover";
    paths = [
      package
      z3
      icu
      boogie
      dotnet-sdk
    ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${bin} \
        --set Z3_EXE ${z3}/bin/z3 \
        --set DOTNET_ROOT ${dotnet-sdk} \
        --set LD_LIBRARY_PATH ${icu}/lib \
        --set BOOGIE_EXE ${boogie}/bin/boogie
    '';
  } else package
