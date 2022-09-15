module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_, delay)

import Test.Spec (pending, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

import Test.Scale (scaleSpec)
import Test.Util (utilSpec)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  scaleSpec
  utilSpec
