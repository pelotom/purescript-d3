module Graphics.D3.Raw.Selection
  ( Selection()
  , d3Select
  , d3SelectAll
  , d3SelectFrom
  , d3SelectAllFrom
  , d3SetData
  , d3Enter
  , d3Exit
  , d3Transition
  , d3Append
  , d3Remove
  , d3SetAttr
  , d3SetText
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

foreign import d3SetData
  "function d3SetData(data) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.data(data);\
  \    };\
  \  };\
  \}"
  :: forall d e. [d] -> Selection -> D3Eff e Selection

foreign import d3Enter
  "function d3Enter(selection) {\
  \  return function () {\
  \    return selection.enter();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import d3Exit
  "function d3Exit(selection) {\
  \  return function () {\
  \    return selection.exit();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import d3Transition
  "function d3Transition(selection) {\
  \  return function () {\
  \    return selection.transition();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import d3Append
  "function d3Append(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import d3Remove
  "function d3Remove(selection) {\
  \  return function () {\
  \    selection.remove();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Unit

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

foreign import d3SetText
  "function d3SetText(text) {\
  \  return function (selection) {\
  \    return function () {\
  \      selection.text(text);\
  \    };\
  \  };\
  \}"
  :: forall a e. a -> Selection -> D3Eff e Unit
