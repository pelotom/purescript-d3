module Graphics.D3.Interpolate
  ( Interpolator()
  , makeInterpolator
  ) where

import Data.Foreign.EasyFFI

ffi = unsafeForeignFunction

foreign import data Interpolator :: * -> *

makeInterpolator :: forall a. (a -> a -> Number -> a) -> Interpolator a
makeInterpolator = ffi ["f"] "function (x, y) { return f(x)(y); }"
