module Graphics.D3.Selection where
  -- ( Selection()
  -- , rootSelect
  -- , rootSelectAll
  -- , select
  -- , selectAll
  -- , bind
  -- , enter
  -- , exit
  -- , transition
  -- , append
  -- , remove
  -- , attr
  -- , style
  -- , text
  -- ) where

import Graphics.D3.Base
import Control.Monad.Eff

foreign import data Selection :: * -> *
foreign import data Enter :: * -> *
foreign import data Transition :: * -> *

-- The (uninhabited) type of an unbound selection's data
data NoData

-- Class for things that both selections and transitions can do
class SelectionOrTransition s
instance selOrTransSelection  :: SelectionOrTransition (Selection d)
instance selOrTransTransition :: SelectionOrTransition (Transition d)

-- Class for things which can be appended to / inserted into
class SelectionOrEnter s where
  append :: forall d. String -> s d -> D3Eff (Selection d)

instance selOrEnterSelection  :: SelectionOrEnter Selection where
  append = appendToSelection

instance selOrEnterEnter      :: SelectionOrEnter Enter where
  append = appendToEnter

type DataJoin d = {
    enter   :: Enter d,
    update  :: Selection d,
    exit    :: Selection d
  }

foreign import rootSelect
  "function rootSelect(selector) {\
  \  return function () {\
  \    return d3.select(selector);\
  \  };\
  \}"
  :: String -> D3Eff (Selection NoData)

foreign import rootSelectAll
  "function rootSelectAll(selector) {\
  \  return function () {\
  \    return d3.selectAll(selector);\
  \  };\
  \}"
  :: String -> D3Eff (Selection NoData)

foreign import select
  "function select(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.select(selector);\
  \    };\
  \  };\
  \}"
  :: forall d. String -> Selection d -> D3Eff (Selection d)

foreign import selectAll
  "function selectAll(selector) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.selectAll(selector);\
  \    };\
  \  };\
  \}"
  :: forall d. String -> Selection d -> D3Eff (Selection NoData)

foreign import bind
  "function bind(data) {\
  \  return function (selection) {\
  \    return function () {\
  \      var update = selection.data(data);\
  \      return { enter: update.enter(), update: update, exit: update.exit() }\
  \    };\
  \  };\
  \}"
  :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (DataJoin newData)

foreign import transition
  "function transition(selection) {\
  \  return function () {\
  \    return selection.transition();\
  \  };\
  \}"
  :: forall d. Selection d -> D3Eff (Transition d)

foreign import appendToSelection
  "function appendToSelection(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \}"
  :: forall d. String -> Selection d -> D3Eff (Selection d)

foreign import appendToEnter
  "function appendToEnter(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \}"
  :: forall d. String -> Enter d -> D3Eff (Selection d)

foreign import remove
  "function remove(selection) {\
  \  return function () {\
  \    selection.remove();\
  \  };\
  \}"
  :: forall s. (SelectionOrTransition s) => s -> D3Eff Unit

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
  :: forall d v s. (SelectionOrTransition s) => String -> (d -> v) -> s -> D3Eff s

foreign import style
  "function style(dict) {\
  \  return function (key) {\
  \    return function (val) {\
  \      return function (selection) {\
  \        return function () {\
  \          return selection.style(key, val);\
  \        };\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall d v s. (SelectionOrTransition s) => String -> (d -> v) -> s -> D3Eff s

foreign import text
  "function text(dict) {\
  \  return function (text) {\
  \    return function (selection) {\
  \      return function () {\
  \        return selection.text(text);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall d s. (SelectionOrTransition s) => (d -> String) -> s -> D3Eff s
