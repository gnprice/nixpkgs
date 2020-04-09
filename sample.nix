{ attr
}:

# usage:
# $ nix-shell -p $(nix-build $(nix-instantiate sample.nix \
#     --argstr attr netmask))

let
  devpkgs = import ./. { };

  inherit (devpkgs) lib;

  pkgs = import <nixpkgs> {
    overlays = [
      (self: super: let
        stdenv = devpkgs.stdenv.override {
          inherit (self.stdenv) initialPath cc shell
            extraNativeBuildInputs;
          allowedRequisites =
            builtins.filter (p: !(lib.hasSuffix ".sh" p))
              super.stdenv.allowedRequisites;
        };

      in {
        devStdenv = stdenv;

        ${attr} = super.${attr}.override {
          inherit stdenv;
        };
      })
    ];
  };
in

# pkgs.devStdenv
pkgs.${attr}
