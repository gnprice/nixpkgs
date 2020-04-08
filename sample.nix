{ attr ? "tmp"
, path
}:

# usage:
# $ nix-shell -p $(nix-build $(nix-instantiate sample.nix \
#     --argstr attr netmask
#     --arg path pkgs/tools/networking/netmask))

let
  devpkgs = import ./. { };

  inherit (devpkgs) lib;

  pkgs = import <nixpkgs> {
    overlays = [
      (self: super: let
        stdenv = devpkgs.stdenv.override {
          initialPath = self.stdenv.initialPath;
          cc = self.gcc;
          shell = self.stdenv.shell;
          extraNativeBuildInputs = [ self.patchelf ];
          allowedRequisites =
            builtins.filter (p: !(lib.hasSuffix ".sh" p))
              super.stdenv.allowedRequisites;
        };

      in {
        devStdenv = stdenv;

        ${attr} = super.callPackage path {
          inherit stdenv;
        };
      })
    ];
  };
in

# pkgs.devStdenv
pkgs.${attr}
