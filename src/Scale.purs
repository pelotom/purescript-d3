module Graphics.D3.Scale
  ( Scale
  , LinearScale()
  , OrdinalScale()
  , linearScale
  , ordinalScale
  , domain
  , range
  , freeze
  , rangeRoundBands
  , rangeBand
  ) where

import Graphics.D3.Base

import Data.Foreign.EasyFFI

ffi = unsafeForeignFunction

-- A base class for all scale types
class Scale s

-- Methods common to all scales

domain :: forall s a. (Scale s) => [a] -> s -> D3Eff s
domain = ffi ["domain", "scale", ""] "scale.domain(domain)"

range :: forall s a. (Scale s) => [a] -> s -> D3Eff s
range = ffi ["range", "scale", ""] "scale.range(range)"

freeze :: forall s a. (Scale s) => s -> D3Eff (a -> Number)
freeze = ffi ["scale"] "scale.copy"

-- Specific scale types

-- Linear scale
foreign import data LinearScale :: *

instance scaleLinear :: Scale LinearScale

-- Linear scale constructor
foreign import linearScale
  "var linearScale = d3.scale.linear"
  :: D3Eff LinearScale

-- Ordinal scale
foreign import data OrdinalScale :: *

instance scaleOrdinal :: Scale OrdinalScale

-- Ordinal scale constructor
foreign import ordinalScale
  "var ordinalScale = d3.scale.ordinal"
  :: D3Eff OrdinalScale

rangeRoundBands :: Number -> Number -> Number -> Number -> OrdinalScale -> D3Eff OrdinalScale
rangeRoundBands = ffi
  ["min", "max", "padding", "outerPadding", "scale", ""]
  "scale.rangeRoundBands([min, max], padding, outerPadding)"

rangeBand :: OrdinalScale -> D3Eff Number
rangeBand = ffi ["scale"] "scale.rangeBand"
