module Graphics.D3.Unsafe (
    unsafeDomain,
    unsafeRange,
    unsafeCopy,
    unsafeToFunction
  ) where

import Graphics.D3.Util (ffi)

unsafeDomain = ffi ["domain", "scale", ""] "scale.domain(domain)"
unsafeRange = ffi ["values", "scale", ""] "scale.range(values)"
unsafeCopy = ffi ["scale", ""] "scale.copy()"
unsafeToFunction = ffi ["scale", ""] "scale.copy()"
