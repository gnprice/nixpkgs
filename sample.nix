{ attr
}:

# Scaffold to build just one package with modified stdenv scripts.
#
# Dependencies come unmodified from <nixpkgs>, including the stdenv's
# toolchain.  This is useful for (a) iterating quickly on changes to
# stdenv scripts (like setup.sh), and (b) more easily comparing the
# build log against a baseline, by keeping inputs' paths the same so
# that any changes caused by changes in the scripts' behavior stand out.
#
# Usage:
# $ nix-shell -p $(nix-build $(nix-instantiate sample.nix \
#     --argstr attr netmask))

let
  devpkgs = import ./. { };
  nixpkgs = import <nixpkgs> { };

  inherit (devpkgs) lib;

  # Graft the scripts from one stdenv onto the toolchain from another.
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
