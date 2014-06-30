module Graphics.D3.Scale
  ( LinearScale()
  , linearScale
  , domain
  , range
  , freeze
  ) where

foreign import data LinearScale :: *

import Graphics.D3.Base

foreign import linearScale
  "var linearScale = d3.scale.linear"
  :: forall e. D3Eff e LinearScale

foreign import domain
  "function domain(min) {\
  \  return function (max) {\
  \    return function (scale) {\
  \      return function () {\
  \        return scale.domain([min, max]);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall e. Number -> Number -> LinearScale -> D3Eff e LinearScale

foreign import range
  "function range(min) {\
  \  return function (max) {\
  \    return function (scale) {\
  \      return function () {\
  \        return scale.range([min, max]);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall e. Number -> Number -> LinearScale -> D3Eff e LinearScale

foreign import freeze
  "function freeze(scale) {\
  \  return function () {\
  \    return scale.copy();\
  \  };\
  \}"
  :: forall e. LinearScale -> D3Eff e (Number -> Number)

