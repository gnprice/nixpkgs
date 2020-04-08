let
  devpkgs = import ./. { };
  nixpkgs = import <nixpkgs> { };

  inherit (devpkgs) lib;

  pkgs = import <nixpkgs> {
    overlays = [
      (self: super: let
        stdenv = devpkgs.stdenv.override {
          initialPath = self.stdenv.initialPath;
          cc = self.gcc;
          shell = self.stdenv.shell;
          extraNativeBuildInputs = [ self.patchelf ];
          allowedRequisites = builtins.filter (p: !(lib.hasSuffix ".sh" p)) super.stdenv.allowedRequisites;
        };

        /*
        stdenv = super.stdenv // {
          defaultNativeBuildInputs =
            builtins.filter (p: lib.hasSuffix ".sh" p) devpkgs.stdenv.defaultNativeBuildInputs
            ++ builtins.filter (p: !(lib.hasSuffix ".sh" p)) super.stdenv.defaultNativeBuildInputs;
        };
        */

        /*
        stdenv1 = devpkgs.stdenv.override {
          shell = super.stdenv.shell;
          cc = super.stdenv.cc;

          extraAttrs = {
            shellPackage = super.stdenv.bash;
          };

          overrides = selfEnv: superEnv: {
            inherit (super.stdenv)
              cc
          # Based on last stage in pkgs/stdenv/linux/default.nix .
            gzip bzip2 xz bash coreutils diffutils findutils gawk
            gnumake gnused gnutar gnugrep gnupatch patchelf
            attr acl zlib pcre libunistring libidn2
            ;
          };
        };
        */

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

/*
{
  inherit devpkgs pkgs lib;
}
*/
# pkgs.netmask
# pkgs.devStdenv
# devpkgs.stdenv


/*
with import <nixpkgs> {
  overlays = [
    (self: super: {
      libxslt = super.libxslt.override { pythonSupport = false; };
      libxml2 = super.libxml2.override { pythonSupport = false; };
    })
  ];
};

libxslt
*/
