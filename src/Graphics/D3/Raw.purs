module Graphics.D3.Raw
  ( Selection()
  , d3Select
  , d3SelectAll
  , d3SelectFrom
  , d3SelectAllFrom
  , d3Enter
  , d3SetData
  , d3AppendTo
  , d3SetAttr
  ) where

import Graphics.D3.Base
import Control.Monad.Eff

foreign import data Selection :: *

foreign import d3Select
  "function d3Select(selector) {\
  \  return function () {\
  \    return d3.select(selector);\
  \  };\
  \}"
  :: forall e. String -> D3Eff e Selection

foreign import d3SelectAll
  "function d3SelectAll(selector) {\
  \  return function () {\
  \    return d3.selectAll(selector);\
  \  };\
  \}"
  :: forall e. String -> D3Eff e Selection

foreign import d3SelectFrom
  "function d3SelectFrom(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.select(selector);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import d3SelectAllFrom
  "function d3SelectAllFrom(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.selectAll(selector);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import d3Enter
  "function d3Enter(selection) {\
  \  return function () {\
  \    return selection.enter();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import d3AppendTo
  "function d3AppendTo(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import d3SetData
  "function d3SetData(data) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.data(data);\
  \    };\
  \  };\
  \}"
  :: forall d e. [d] -> Selection -> D3Eff e Selection

foreign import d3SetAttr
  "function d3SetAttr(key) {\
  \  return function (val) {\
  \    return function (selection) {\
  \      return function () {\
  \        selection.attr(key, val);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall a e. String -> a -> Selection -> D3Eff e Unit
