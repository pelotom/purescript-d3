module Graphics.D3.Scale
  ( Scale
  , LinearScale()
  , OrdinalScale()
  , linearScale
  , ordinalScale
  , domain
  , range
  , copy
  , toFunction
  , rangePoints
  , rangeBands
  , rangeRoundBands
  , rangeBand
  , rangeExtent
  ) where

import Graphics.D3.Base

import Data.Tuple

import Data.Foreign.EasyFFI

ffi = unsafeForeignFunction

-- A base class for all scale types
class Scale s where
  domain :: forall d r. [d] -> s d r -> D3Eff (s d r)
  range :: forall d r. [r] -> s d r -> D3Eff (s d r)
  copy :: forall d r. s d r -> D3Eff (s d r)
  toFunction :: forall d r. s d r -> D3Eff (d -> r)

unsafeDomain = ffi ["domain", "scale", ""] "scale.domain(domain)"
unsafeRange = ffi ["range", "scale", ""] "scale.range(range)"
unsafeCopy = ffi ["scale", ""] "scale.copy()"
unsafeToFunction = ffi ["scale", ""] "scale.copy()"

-- Specific scale types

-- Linear scale
foreign import data LinearScale :: * -> * -> *

instance scaleLinear :: Scale LinearScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

-- Linear scale constructor
foreign import linearScale
  "var linearScale = d3.scale.linear"
  :: forall r. D3Eff (LinearScale Number r)

-- Ordinal scale
foreign import data OrdinalScale :: * -> * -> *

instance scaleOrdinal :: Scale OrdinalScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

-- Ordinal scale constructor
foreign import ordinalScale
  "var ordinalScale = d3.scale.ordinal"
  :: forall d r. D3Eff (OrdinalScale d r)

rangePoints :: forall d. Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
rangePoints = ffi
  ["min", "max", "padding", "scale", ""]
  "scale.rangePoints([min, max], padding)"

rangeBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
rangeBands = ffi
  ["min", "max", "padding", "outerPadding", "scale", ""]
  "scale.rangeBands([min, max], padding, outerPadding)"

rangeRoundBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
rangeRoundBands = ffi
  ["min", "max", "padding", "outerPadding", "scale", ""]
  "scale.rangeRoundBands([min, max], padding, outerPadding)"

rangeBand :: forall d r. OrdinalScale d Number -> D3Eff Number
rangeBand = ffi ["scale"] "scale.rangeBand"

rangeExtent :: forall d r. OrdinalScale d Number -> D3Eff (Tuple Number Number)
rangeExtent scale = do
  [min, max] <- ffi ["scale"] "scale.rangeExtent" scale
  return $ Tuple min max
