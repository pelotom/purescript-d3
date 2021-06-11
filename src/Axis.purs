module Graphics.D3.SVG.Axis
  ( Axis()
  , axisBottom
  , scale
  , orient
  , ticks
  , tickFormat
  , renderAxis
  ) where

import Prelude (($), pure)

import Data.Function.Uncurried (Fn1, runFn1, Fn2, runFn2)
import FFI.Simple ((..))
import Effect.Uncurried (EffectFn1, runEffectFn1, EffectFn2, runEffectFn2)

import Graphics.D3.Base (d3, D3, D3Eff)
import Graphics.D3.Selection (class Existing, Selection)
import Graphics.D3.Scale (class Scale)
import Graphics.D3.Util (ffi, ffiD3)

foreign import data Axis :: Type

foreign import axisBottomImpl :: EffectFn1 D3 Axis

axisBottom :: forall s d. (Scale s) => s d Number -> D3Eff Axis
axisBottom = ffiD3 ["scale", ""] "d3.axisBottom(scale)"

foreign import scaleImpl :: forall s d. (Scale s) => EffectFn2 (s d Number) Axis Axis

scale :: forall s d. (Scale s) => s d Number -> Axis -> D3Eff Axis
scale = runEffectFn2 scaleImpl


orient :: String -> Axis -> D3Eff Axis
orient = ffi ["orientation", "axis", ""] "axis.orient(orientation)"

ticks :: Number -> Axis -> D3Eff Axis
ticks = ffi ["count", "axis", ""] "axis.ticks(count)"

tickFormat :: String -> Axis -> D3Eff Axis
tickFormat = ffi ["format", "axis", ""] "axis.tickFormat(d3.format(format))"

renderAxis :: forall s d. (Existing s) => Axis -> s d -> D3Eff (Selection d)
renderAxis = ffi ["axis", "selection", ""] "selection.call(axis)"
