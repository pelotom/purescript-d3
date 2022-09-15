module Test.Scale where

import Prelude

import Effect.Class (liftEffect)
import Test.Spec (pending, describe, it, Spec)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

import Graphics.D3.Scale

scaleSpec :: Spec Unit
scaleSpec = do
  describe "scale-spec" do
    describe "linearScale" do
      it "linear scale works" do
        scale <- liftEffect $ linearScale
          >>= domain [-10.0, 10.0]
          >>= range [0.0, 1.0]
          >>= toFunction
        (scale 0.0) `shouldEqual` 0.5
        (scale 5.0) `shouldEqual` 0.75
        (scale (-5.0)) `shouldEqual` 0.25
