source $stdenv/setup
export PREFIX=$out
configureFlagsArray+=( --plugin-path=$out/lib/mozilla/plugins )
genericBuild
