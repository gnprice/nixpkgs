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
      builtins.filter (p: !(lib.hasSuffix ".sh" p))
        base.allowedRequisites;
  };

  devStdenv = graftStdenv nixpkgs.stdenv devpkgs.stdenv;
in

nixpkgs.${attr}.override {
  stdenv = devStdenv;
}
