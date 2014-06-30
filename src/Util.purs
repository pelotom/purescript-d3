module Graphics.D3.Util
  ( min
  , max
  , (..)
  ) where

foreign import min
  "var min = d3.min"
  :: [Number] -> Number

foreign import max
  "var max = d3.max"
  :: [Number] -> Number

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
(..) = (>>=)
