let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.4-20220901/packages.dhall sha256:f1531b29c21ac437ffe5666c1b6cc76f0a9c29d3c9d107ff047aa2567744994f

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
      --, "spec-mocha"
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
    , version = "v0.4.0"
    }
  }

in  (upstream // additions)
