module Graphics.D3.Unsafe (
    unsafeDomain,
    unsafeRange,
    unsafeCopy,
    unsafeToFunction
  ) where

import Data.Foreign.EasyFFI

ffi = unsafeForeignFunction

unsafeDomain = ffi ["domain", "scale", ""] "scale.domain(domain)"
unsafeRange = ffi ["values", "scale", ""] "scale.range(values)"
unsafeCopy = ffi ["scale", ""] "scale.copy()"
unsafeToFunction = ffi ["scale", ""] "scale.copy()"
