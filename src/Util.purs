module Graphics.D3.Util
  ( class Magnitude
  , min
  , max
  , min'
  , max'
  , extent
  , extent'
  , (..)
  , (...)
  ) where

import Data.Foreign.EasyFFI
import Data.JSDate (JSDate)

import Control.Bind (bind)
import Data.Function (applyFlipped)

class Magnitude n

instance numberMagnitude :: Magnitude Number
instance dateMagnitude :: Magnitude JSDate

min' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> m
min' = unsafeForeignFunction ["fn", "data"] "d3.min(data, fn)"

max' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> m
max' = unsafeForeignFunction ["fn", "data"] "d3.max(data, fn)"

min :: forall m. (Magnitude m) => Array m -> m
min = unsafeForeignFunction ["data"] "d3.min(data)"

max :: forall m. (Magnitude m) => Array m -> m
max = unsafeForeignFunction ["data"] "d3.max(data)"

-- extent takes a data array and returns [min,max]
-- not restricted to Number, i.e. also works with time
extent :: forall m. (Magnitude m) => Array m -> Array m
extent = unsafeForeignFunction ["data"] "d3.extent(data)"

extent' :: forall d m. (Magnitude m) => (d->m) -> Array d -> Array m
extent' = unsafeForeignFunction ["fn", "data"] "d3.extent(data, fn)"

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
infixl 4 bind as ..

-- Reversed function application, useful for applying extended monadic chains
-- to already-obtained values
infixl 4 applyFlipped as ...

