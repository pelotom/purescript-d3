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

foreign import data Selection :: # * -> *

foreign import rootSelect
  "function rootSelect(selector) {\
  \  return function () {\
  \    return d3.select(selector);\
  \  };\
  \}"
  :: String -> D3Eff (Selection (exists :: Unit))

foreign import rootSelectAll
  "function rootSelectAll(selector) {\
  \  return function () {\
  \    return d3.selectAll(selector);\
  \  };\
  \}"
  :: String -> D3Eff (Selection (exists :: Unit))

foreign import select
  "function select(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.select(selector);\
  \    };\
  \  };\
  \}"
  :: forall r. String -> Selection (exists :: Unit | r) -> D3Eff (Selection (exists :: Unit | r))

foreign import selectAll
  "function selectAll(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.selectAll(selector);\
  \    };\
  \  };\
  \}"
  :: forall r. String -> Selection (exists :: Unit | r) -> D3Eff (Selection (exists :: Unit | r))

foreign import bind
  "function bind(data) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.data(data);\
  \    };\
  \  };\
  \}"
  :: forall d r. [d] -> Selection (exists :: Unit | r) -> D3Eff (Selection (exists :: Unit, hasData :: d, isJoin :: Unit | r))

foreign import enter
  "function enter(selection) {\
  \  return function () {\
  \    return selection.enter();\
  \  };\
  \}"
  :: forall r. Selection (isJoin :: Unit, exists :: Unit | r) -> D3Eff (Selection r)

foreign import exit
  "function exit(selection) {\
  \  return function () {\
  \    return selection.exit();\
  \  };\
  \}"
  :: forall r. Selection (isJoin :: Unit | r) -> D3Eff (Selection r)

foreign import transition
  "function transition(selection) {\
  \  return function () {\
  \    return selection.transition();\
  \  };\
  \}"
  :: forall r. Selection r -> D3Eff (Selection r)

foreign import append
  "function append(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \}"
  :: forall r. String -> Selection r -> D3Eff (Selection (exists :: Unit | r))

foreign import remove
  "function remove(selection) {\
  \  return function () {\
  \    selection.remove();\
  \  };\
  \}"
  :: forall r. Selection r -> D3Eff Unit

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
  :: forall d v r. String -> (d -> v) -> Selection (hasData :: d | r) -> D3Eff (Selection (hasData :: d | r))

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
  :: forall d v r. String -> (d -> v) -> Selection (hasData :: d | r) -> D3Eff (Selection (hasData :: d | r))

foreign import text
  "function text(text) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.text(text);\
  \    };\
  \  };\
  \}"
  :: forall d r. (d -> String) -> Selection (hasData :: d | r) -> D3Eff (Selection (hasData :: d | r))
