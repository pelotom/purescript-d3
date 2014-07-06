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
import Data.Foreign.EasyFFI

-- The "selection-y" types, parameterized by the type of their bound data
foreign import data Selection :: * -> *
foreign import data Update :: * -> *
foreign import data Enter :: * -> *
foreign import data Transition :: * -> *

-- Exit selections have the same semantics as regular selections
type Exit d = Selection d

-- The (uninhabited) type of an unbound selection's data
data Void

rootSelect :: String -> D3Eff (Selection Void)
rootSelect = unsafeForeignFunction ["selector", ""] "d3.select(selector)"

rootSelectAll :: String -> D3Eff (Selection Void)
rootSelectAll = unsafeForeignFunction ["selector", ""] "d3.selectAll(selector)"

select :: forall d. String -> Selection d -> D3Eff (Selection d)
select = unsafeForeignFunction ["selector", "selection", ""] "selection.select(selector)"

selectAll :: forall d. String -> Selection d -> D3Eff (Selection Void)
selectAll = unsafeForeignFunction ["selector", "selection", ""] "selection.selectAll(selector)"

bind :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (Update newData)
bind = unsafeForeignFunction ["array", "selection", ""] "selection.data(array)"

enter :: forall d. Update d -> D3Eff (Enter d)
enter = unsafeForeignFunction ["update", ""] "update.enter()"

exit :: forall d. Update d -> D3Eff (Exit d)
exit = unsafeForeignFunction ["update", ""] "update.exit()"

transition :: forall d. Selection d -> D3Eff (Transition d)
transition = unsafeForeignFunction ["selection", ""] "selection.transition()"

unsafeAppend :: forall x y. String -> x -> D3Eff y
unsafeAppend = unsafeForeignFunction ["tag", "selection", ""] "selection.append(tag)"

unsafeRemove :: forall s. s -> D3Eff Unit
unsafeRemove = unsafeForeignProcedure ["selection", ""] "selection.remove();"

unsafeAttr :: forall d v s. String -> (d -> v) -> s -> D3Eff s
unsafeAttr = unsafeForeignFunction ["key", "val", "selection", ""] "selection.attr(key, val)"

unsafeStyle :: forall d v s. String -> (d -> v) -> s -> D3Eff s
unsafeStyle = unsafeForeignFunction ["key", "val", "selection", ""] "selection.style(key, val)"

unsafeText :: forall d s. (d -> String) -> s -> D3Eff s
unsafeText = unsafeForeignFunction ["text", "selection", ""] "selection.text(text)"

-- Selection-y things which can be appended to / inserted into
class Appendable s where
  append :: forall d. String -> s d -> D3Eff (Selection d)

instance appendableSelection  :: Appendable Selection where
  append = unsafeAppend

instance appendableUpdate     :: Appendable Update where
  append = unsafeAppend

instance appendableEnter      :: Appendable Enter where
  append = unsafeAppend

-- Selection-y things that contain existing DOM elements
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
