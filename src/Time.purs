module Graphics.D3.Time (
	TimeScale(),
	timeScale
  ) where
import Data.Foreign.EasyFFI
import Data.Date
import Graphics.D3.Base
import Graphics.D3.Scale

foreign import data TimeScale :: * -> * -> *
foreign import timeScale "var timeScale = d3.time.scale"
  :: forall r. D3Eff (TimeScale JSDate r)

instance scaleTime :: Scale TimeScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

ffi = unsafeForeignFunction
unsafeDomain = ffi ["domain", "scale", ""] "scale.domain(domain)"
unsafeRange = ffi ["values", "scale", ""] "scale.range(values)"
unsafeCopy = ffi ["scale", ""] "scale.copy()"
unsafeToFunction = ffi ["scale", ""] "scale.copy()"