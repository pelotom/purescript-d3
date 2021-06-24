{ name = "purescript-d3"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "dom-simple"
  , "easy-ffi"
  , "effect"
  , "exceptions"
  , "foreign"
  , "functions"
  , "js-date"
  , "maybe"
  , "prelude"
  , "psci-support"
  , "tuples"
  , "web-dom"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
