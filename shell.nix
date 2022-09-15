let
  pkgs = import <nixpkgs> {};
  default-shell = import (
    pkgs.fetchFromGitHub {
      owner = "garganscript";
      repo = "package-sets";
      rev = "master";
      sha256 = "1z7x5g0ba62l6hiagwsmnmdg07mz5xwf35qvb9p7fry2lks1ma18";
    } + "/default-shell.nix");
in
pkgs.mkShell {
  name = "purescript-d3";

  buildInputs = [
    default-shell.purs
    default-shell.easy-ps.psc-package
    default-shell.easy-ps.spago
    default-shell.build
    default-shell.pkgs.dhall-json
    pkgs.esbuild
  ];
}
