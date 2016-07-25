module Graphics.D3.SVG.Axis
  ( Axis()
  , axis
  , scale
  , orient
  , ticks
  , tickFormat
  , renderAxis
  ) where

import Graphics.D3.Base (D3Eff)
import Graphics.D3.Selection (class Existing, Selection)
import Graphics.D3.Scale (class Scale)

import Data.Foreign.EasyFFI (unsafeForeignFunction)

ffi = unsafeForeignFunction

foreign import data Axis :: *

foreign import axis :: D3Eff Axis

scale :: forall s d. (Scale s) => s d Number -> Axis -> D3Eff Axis
scale = ffi ["scale", "axis", ""] "axis.scale(scale)"

orient :: String -> Axis -> D3Eff Axis
orient = ffi ["orientation", "axis", ""] "axis.orient(orientation)"

ticks :: Number -> Axis -> D3Eff Axis
ticks = ffi ["count", "axis", ""] "axis.ticks(count)"

tickFormat :: String -> Axis -> D3Eff Axis
tickFormat = ffi ["format", "axis", ""] "axis.tickFormat(d3.format(format))"

renderAxis :: forall s d. (Existing s) => Axis -> s d -> D3Eff (Selection d)
renderAxis = ffi ["axis", "selection", ""] "selection.call(axis)"
