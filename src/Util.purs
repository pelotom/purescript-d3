module Graphics.D3.Util
  ( min
  , max
  , (..)
  , (...)
  ) where

import Data.Foreign.EasyFFI

min :: forall d. (d -> Number) -> [d] -> Number
min = unsafeForeignFunction ["fn", "data"] "d3.min(data, fn)"

max :: forall d. (d -> Number) -> [d] -> Number
max = unsafeForeignFunction ["fn", "data"] "d3.max(data, fn)"

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
(..) = (>>=)

-- Reversed function application, useful for applying extended monadic chains
-- to already-obtained values
(...) = flip ($)