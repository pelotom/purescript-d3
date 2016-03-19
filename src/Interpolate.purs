module Graphics.D3.Interpolate
  ( Interpolator()
  , makeInterpolator
  ) where

import Graphics.D3.Unsafe (ffi)

foreign import data Interpolator :: * -> *

makeInterpolator :: forall a. (a -> a -> Number -> a) -> Interpolator a
makeInterpolator = ffi ["f"] "function (x, y) { return f(x)(y); }"
