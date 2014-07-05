module Graphics.D3.Selection
  ( Selection()
  , Update()
  , Enter()
  , Exit()
  , Transition()
  , Void()
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

-- The "selection-y" types, parameterized by the type of their bound data
foreign import data Selection :: * -> *
foreign import data Update :: * -> *
foreign import data Enter :: * -> *
foreign import data Transition :: * -> *

-- Exit selections have the same semantics as regular selections
type Exit d = Selection d

-- The (uninhabited) type of an unbound selection's data
data Void

-- Class for things that contain existing DOM elements (most selection-y
-- things except for Enter)
class Existing s where
  attr :: forall d v. String -> (d -> v) -> s d -> D3Eff (s d)
  style :: forall d v. String -> (d -> v) -> s d -> D3Eff (s d)
  text :: forall d. (d -> String) -> s d -> D3Eff (s d)
  remove :: forall d. s d -> D3Eff Unit

instance existingSelection  :: Existing Selection where
  attr = unsafeAttr
  style = unsafeStyle
  text = unsafeText
  remove = unsafeRemove

instance existingUpdate     :: Existing Update where
  attr = unsafeAttr
  style = unsafeStyle
  text = unsafeText
  remove = unsafeRemove

instance existingTransition :: Existing Transition where
  attr = unsafeAttr
  style = unsafeStyle
  text = unsafeText
  remove = unsafeRemove

-- Selection-y things which can be appended to / inserted into
class Appendable s where
  append :: forall d. String -> s d -> D3Eff (Selection d)

instance appendableSelection  :: Appendable Selection where
  append = unsafeAppend

instance appendableUpdate     :: Appendable Update where
  append = unsafeAppend

instance appendableEnter      :: Appendable Enter where
  append = unsafeAppend

foreign import rootSelect
  "function rootSelect(selector) {\
  \  return function () {\
  \    return d3.select(selector);\
  \  };\
  \}"
  :: String -> D3Eff (Selection Void)

foreign import rootSelectAll
  "function rootSelectAll(selector) {\
  \  return function () {\
  \    return d3.selectAll(selector);\
  \  };\
  \}"
  :: String -> D3Eff (Selection Void)

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
  :: forall d. String -> Selection d -> D3Eff (Selection Void)

foreign import bind
  "function bind(data) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.data(data);\
  \    };\
  \  };\
  \}"
  :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (Update newData)

foreign import enter
  "function enter(selection) {\
  \  return function () {\
  \    return selection.enter();\
  \  };\
  \}"
  :: forall d. Update d -> D3Eff (Enter d)

foreign import exit
  "function exit(selection) {\
  \  return function () {\
  \    return selection.exit();\
  \  };\
  \}"
  :: forall d. Update d -> D3Eff (Exit d)

foreign import transition
  "function transition(selection) {\
  \  return function () {\
  \    return selection.transition();\
  \  };\
  \}"
  :: forall d. Selection d -> D3Eff (Transition d)

foreign import unsafeAppend
  "function unsafeAppend(tag) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.append(tag);\
  \    };\
  \  };\
  \};"
  :: forall x y. String -> x -> D3Eff y

foreign import unsafeRemove
  "function unsafeRemove(selection) {\
  \  return function () {\
  \    selection.remove();\
  \  };\
  \}"
  :: forall s. s -> D3Eff Unit

foreign import unsafeAttr
  "function unsafeAttr(key) {\
  \  return function (val) {\
  \    return function (selection) {\
  \      return function () {\
  \        return selection.attr(key, val);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall d v s. String -> (d -> v) -> s -> D3Eff s

foreign import unsafeStyle
  "function unsafeStyle(key) {\
  \  return function (val) {\
  \    return function (selection) {\
  \      return function () {\
  \        return selection.style(key, val);\
  \      };\
  \    };\
  \  };\
  \}"
  :: forall d v s. String -> (d -> v) -> s -> D3Eff s

foreign import unsafeText
  "function unsafeText(text) {\
  \  return function (selection) {\
  \    return function () {\
  \      return selection.text(text);\
  \    };\
  \  };\
  \}"
  :: forall d s. (d -> String) -> s -> D3Eff s
