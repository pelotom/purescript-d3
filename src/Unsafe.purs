module Graphics.D3.Unsafe (
        ffi,
	unsafeDomain,
	unsafeRange,
	unsafeCopy,
	unsafeToFunction
  ) where

import Data.Foreign.EasyFFI

ffi :: forall t. Array String -> String -> t
ffi = unsafeForeignFunction

unsafeDomain :: forall t. t
unsafeDomain = ffi ["domain", "scale", ""] "scale.domain(domain)"

unsafeRange :: forall t. t
unsafeRange = ffi ["values", "scale", ""] "scale.range(values)"

unsafeCopy :: forall t. t
unsafeCopy = ffi ["scale", ""] "scale.copy()"

unsafeToFunction :: forall t. t
unsafeToFunction = ffi ["scale", ""] "scale.copy()"
