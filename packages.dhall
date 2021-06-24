let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.2/packages.dhall sha256:64d7b5a1921e8458589add8a1499a1c82168e726a87fc4f958b3f8760cca2efe

let additions =
  { dom-simple =
    { dependencies =
      [ "arrays"
      , "console"
      , "effect"
      , "ffi-simple"
      , "functions"
      , "nullable"
      , "prelude"
      , "spec"
      , "spec-mocha"
      , "unsafe-coerce"
      ]
    , repo = "https://github.com/poorscript/purescript-dom-simple"
    , version = "v0.2.7"
    }
  , ffi-simple =
    { dependencies =
      [ "prelude"
      , "effect"
      , "maybe"
      , "functions"
      , "nullable"
      , "unsafe-coerce"
      ]
    , repo = "https://github.com/poorscript/purescript-ffi-simple"
    , version = "v0.2.10"
    }
  }

in  (upstream // additions)
