module Graphics.D3.Time (
	TimeScale(),
	timeScale
  ) where
import Data.JSDate (JSDate)
import Graphics.D3.Base (D3Eff)
import Graphics.D3.Scale (class Scale)
import Graphics.D3.Unsafe

foreign import data TimeScale :: * -> * -> *
foreign import timeScale :: forall r. D3Eff (TimeScale JSDate r)

instance scaleTime :: Scale TimeScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction
