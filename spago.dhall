{ name = "purescript-d3"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "easy-ffi"
  , "effect"
  , "either"
  , "exceptions"
  , "foreign"
  , "functions"
  , "js-date"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "tuples"
  , "typelevel-prelude"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
