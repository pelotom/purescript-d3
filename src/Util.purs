module Graphics.D3.Util
  ( min
  , max
  , maxBy
  , (..)
  , (...)
  ) where

import Data.Foreign.EasyFFI

foreign import min "var min = d3.min" :: [Number] -> Number
minBy :: forall d. (d -> Number) -> [d] -> Number
minBy = unsafeForeignFunction ["fn", "data"] "d3.min(data, fn)"

foreign import max "var max = d3.max" :: [Number] -> Number
maxBy :: forall d. (d -> Number) -> [d] -> Number
maxBy = unsafeForeignFunction ["fn", "data"] "d3.max(data, fn)"

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
(..) = (>>=)

-- Reversed function application, useful for applying extended monadic chains
-- to already-obtained values
(...) = flip ($)