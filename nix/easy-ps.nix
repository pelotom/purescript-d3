{ pkgs ? import ./pinned.nix { } }:

import
  (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "master";
      # sha256 = "1lcdzsiyrwnmkq58594c2d26qlnvany2268bnik08qwhv508dk1r";
      sha256 = "1b59dddrkdvh0i26any5g7lxxaxnn9af61dhxbb9bdb5n831dviw";
    }
  ) {
  inherit pkgs;
}
