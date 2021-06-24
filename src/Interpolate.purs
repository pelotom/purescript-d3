module Graphics.D3.Interpolate
  ( Interpolator()
  , makeInterpolator
  ) where

import Graphics.D3.Util (ffi)

foreign import data Interpolator :: Type -> Type

makeInterpolator :: forall a. (a -> a -> Number -> a) -> Interpolator a
makeInterpolator = ffi ["f"] "function (x, y) { return f(x)(y); }"
