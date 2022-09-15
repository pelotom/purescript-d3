{ name = "purescript-d3"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "dom-simple"
  , "effect"
  , "exceptions"
  , "foreign"
  , "functions"
  , "js-date"
  , "maybe"
  , "prelude"
  --, "psci-support"
  , "small-ffi"
  , "tuples"
  , "web-dom"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
