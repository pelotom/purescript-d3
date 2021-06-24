module Graphics.D3.Time (
    TimeScale(),
    scaleTime
  ) where

import Data.Function.Uncurried (Fn1, runFn1)
import Data.JSDate (JSDate)
import Effect.Uncurried (EffectFn1, runEffectFn1)

import Graphics.D3.Base (d3, D3, D3Eff)
import Graphics.D3.Scale (class Scale)
import Graphics.D3.Unsafe

foreign import data TimeScale :: Type -> Type -> Type
foreign import scaleTimeImpl :: forall r. Fn1 D3 (D3Eff (TimeScale JSDate r))

scaleTime :: forall r. D3Eff (TimeScale JSDate r)
scaleTime = scaleTimeImpl d3

instance scaleTimeScale :: Scale TimeScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction
