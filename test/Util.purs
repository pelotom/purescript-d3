module Test.Util where

import Prelude

import Effect.Class (liftEffect)
import Test.Spec (pending, describe, it, Spec)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

import Graphics.D3.Util

utilSpec :: Spec Unit
utilSpec = do
  describe "util-spec" do
    describe "extent" do
      it "extent works" do
        (extent [1.0, 2.0, 3.0]) `shouldEqual` [1.0, 3.0]
