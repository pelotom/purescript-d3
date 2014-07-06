module Graphics.D3.Scale
  ( Scale
  , LinearScale()
  , linearScale
  , domain
  , range
  , freeze
  ) where

import Graphics.D3.Base
import Data.Foreign.EasyFFI

-- A base class for all scale types
class Scale s

-- Linear scale
foreign import data LinearScale :: *
foreign import linearScale
  "var linearScale = d3.scale.linear"
  :: D3Eff LinearScale
instance scaleLinear :: Scale LinearScale

domain :: forall s a. (Scale s) => [a] -> s -> D3Eff s
domain = unsafeForeignFunction ["domain", "scale", ""] "scale.domain(domain)"

range :: forall s a. (Scale s) => [a] -> s -> D3Eff s
range = unsafeForeignFunction ["range", "scale", ""] "scale.range(range)"

freeze :: forall s. (Scale s) => s -> D3Eff (Number -> Number)
freeze = unsafeForeignFunction ["scale", ""] "scale.copy()"

