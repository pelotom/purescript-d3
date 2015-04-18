module Graphics.D3.Util
  ( Magnitude
  , min
  , max
  , min'
  , max'
  , extent
  , (..)
  , (...)
  ) where

import Data.Foreign.EasyFFI
import Data.Date

class Magnitude n

instance numberMagnitude :: Magnitude Number
instance dateMagnitude :: Magnitude JSDate

min' :: forall d m. (Magnitude m) => (d -> m) -> [d] -> m
min' = unsafeForeignFunction ["fn", "data"] "d3.min(data, fn)"

max' :: forall d m. (Magnitude m) => (d -> m) -> [d] -> m
max' = unsafeForeignFunction ["fn", "data"] "d3.max(data, fn)"

min :: forall m. (Magnitude m) => [m] -> m
min = unsafeForeignFunction ["data"] "d3.min(data)"

max :: forall d m. (Magnitude m) => [m] -> m
max = unsafeForeignFunction ["data"] "d3.max(data)"

-- extent takes a data array and returns [min,max]
-- not restricted to Number, i.e. also works with time
extent :: forall m. (Magnitude m) => [m] -> [m]
extent = unsafeForeignFunction ["data"] "d3.extent(data)"

extent' :: forall d m. (Magnitude m) => (d->m) -> [d] -> [m]
extent' = unsafeForeignFunction ["fn", "data"] "d3.extent(data, fn)"

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
(..) = (>>=)

-- Reversed function application, useful for applying extended monadic chains
-- to already-obtained values
(...) = flip ($)