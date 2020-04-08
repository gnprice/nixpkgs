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

        netmask = super.callPackage pkgs/tools/networking/netmask {
          inherit stdenv;
        };
      })
    ];
  };
in

# pkgs.devStdenv
pkgs.netmask
