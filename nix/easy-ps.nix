{ pkgs ? import ./pinned.nix { } }:

import
  (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "master";
      sha256 = "03g9xq451dmrkq8kiz989wnl8k0lmj60ajflz44bhp7cm08hf3bw";
    }
  ) {
  inherit pkgs;
}
