{ attr
}:

# usage:
# $ nix-shell -p $(nix-build $(nix-instantiate sample.nix \
#     --argstr attr netmask))

let
  devpkgs = import ./. { };
  nixpkgs = import <nixpkgs> { };

  inherit (devpkgs) lib;

  graftStdenv = base: scripts: scripts.override {
    inherit (base) initialPath cc shell extraNativeBuildInputs;
    allowedRequisites =
      if base ? allowedRequisites then
        builtins.filter (p: !(lib.hasSuffix ".sh" p))
          base.allowedRequisites
      else null;
  };

  devStdenv = graftStdenv nixpkgs.stdenv devpkgs.stdenv;
in

(lib.getAttrFromPath (lib.splitString "." attr) nixpkgs).override (
  old: {
    stdenv = graftStdenv old.stdenv devpkgs.stdenv;
  })
