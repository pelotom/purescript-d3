module Graphics.D3.Util
  ( ffi
  , ffiD3
  , class Magnitude
  , min
  , max
  , min'
  , max'
  , extent
  , extent'
  , (..)
  , (...)
  ) where

import Prelude

import Data.Foreign.SmallFFI
import Data.JSDate (JSDate)

import Control.Bind (bind)
import Data.Function (applyFlipped)

import Graphics.D3.Base (d3)

ffi :: forall a. Array String -> String -> a
ffi = unsafeForeignFunction
-- Utility function to apply unsafeForeignFunction with d3
--
-- If we don't use this, Graphics.D3.Base might have dead code eliminated and we
-- end up without window.d3 in scope
ffiD3 :: forall t. Array String -> String -> t
ffiD3 args fun = unsafeForeignFunction (["d3"] <> args) fun $ d3

class Magnitude n

instance numberMagnitude :: Magnitude Number
instance dateMagnitude :: Magnitude JSDate

min' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> m
min' = ffiD3 ["fn", "data"] "d3.min(data, fn)"

max' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> m
max' = ffiD3 ["fn", "data"] "d3.max(data, fn)"

min :: forall m. (Magnitude m) => Array m -> m
min = ffiD3 ["data"] "d3.min(data)"

max :: forall m. (Magnitude m) => Array m -> m
max = ffiD3 ["data"] "d3.max(data)"

-- extent takes a data array and returns [min,max]
-- not restricted to Number, i.e. also works with time
extent :: forall m. (Magnitude m) => Array m -> Array m
extent = ffiD3 ["data"] "d3.extent(data)"

extent' :: forall d m. (Magnitude m) => (d->m) -> Array d -> Array m
extent' = ffiD3 ["fn", "data"] "d3.extent(data, fn)"

-- Syntactic sugar to make chained monadic statements look similar to the
-- "fluid interface" style of chained method calls in JavaScript
infixl 4 bind as ..

-- Reversed function application, useful for applying extended monadic chains
-- to already-obtained values
infixl 4 applyFlipped as ...
