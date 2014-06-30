module Graphics.D3.Selection
  ( Selection()
  , rootSelect
  , rootSelectAll
  , select
  , selectAll
  , bind
  , enter
  , exit
  , transition
  , append
  , remove
  , attr
  , style
  , text
  ) where

import Graphics.D3.Base
import Control.Monad.Eff

foreign import data Selection :: *

foreign import rootSelect
  "function rootSelect(selector) {\
  \  return function () {\
  \    return d3.select(selector);\
  \  };\
  \}"
  :: forall e. String -> D3Eff e Selection

foreign import rootSelectAll
  "function rootSelectAll(selector) {\
  \  return function () {\
  \    return d3.selectAll(selector);\
  \  };\
  \}"
  :: forall e. String -> D3Eff e Selection

foreign import select
  "function select(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.select(selector);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import selectAll
  "function selectAll(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.selectAll(selector);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import bind
  "function bind(data) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.data(data);\
  \    };\
  \  };\
  \}"
  :: forall d e. [d] -> Selection -> D3Eff e Selection

foreign import enter
  "function enter(selection) {\
  \  return function () {\
  \    return selection.enter();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import exit
  "function exit(selection) {\
  \  return function () {\
  \    return selection.exit();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import transition
  "function transition(selection) {\
  \  return function () {\
  \    return selection.transition();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Selection

foreign import append
  "function append(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \}"
  :: forall e. String -> Selection -> D3Eff e Selection

foreign import remove
  "function remove(selection) {\
  \  return function () {\
  \    selection.remove();\
  \  };\
  \}"
  :: forall e. Selection -> D3Eff e Unit

foreign import attr
  "function attr(key) {\
  \  return function (val) {\
  \    return function (selection) {\
  \      return function () {\
  \        return selection.attr(key, val);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall a e. String -> a -> Selection -> D3Eff e Selection

foreign import style
  "function style(key) {\
  \  return function (val) {\
  \    return function (selection) {\
  \      return function () {\
  \        return selection.style(key, val);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall a e. String -> a -> Selection -> D3Eff e Selection

foreign import text
  "function text(text) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.text(text);\
  \    };\
  \  };\
  \}"
  :: forall a e. a -> Selection -> D3Eff e Selection
