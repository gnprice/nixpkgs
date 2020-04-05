source $stdenv/setup

configureFlagsArray+=( -prefix $out )
genericBuild

#cd emacs/
#mkdir -p $out/share/ocaml/emacs
#make EMACSDIR=$out/share/ocaml/emacs install
