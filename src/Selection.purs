module Graphics.D3.Selection
  ( Selection()
  , Update()
  , Enter()
  , Exit()
  , Transition()
  , Void()
  , AttrValue
  , Existing
  , Appendable
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
  , attr'
  , attr''
  , style
  , style'
  , style''
  , text
  , text'
  , text''
  ) where

import Graphics.D3.Base
import Control.Monad.Eff

import Data.Foreign.EasyFFI

ffi = unsafeForeignFunction

-- The "selection-y" types, parameterized by the type of their bound data
foreign import data Selection :: * -> *
foreign import data Update :: * -> *
foreign import data Enter :: * -> *
foreign import data Transition :: * -> *

-- Exit selections have the same semantics as regular selections
type Exit d = Selection d

-- The (uninhabited) type of an unbound selection's data
data Void

-- The class of types which element attribute values can have (numbers and strings)
class AttrValue a

instance attrValNumber :: AttrValue Number
instance attrValString :: AttrValue String

rootSelect :: String -> D3Eff (Selection Void)
rootSelect = ffi ["selector", ""] "d3.select(selector)"

rootSelectAll :: String -> D3Eff (Selection Void)
rootSelectAll = ffi ["selector", ""] "d3.selectAll(selector)"

select :: forall d. String -> Selection d -> D3Eff (Selection d)
select = ffi ["selector", "selection", ""] "selection.select(selector)"

selectAll :: forall d. String -> Selection d -> D3Eff (Selection Void)
selectAll = ffi ["selector", "selection", ""] "selection.selectAll(selector)"

bind :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (Update newData)
bind = ffi ["array", "selection", ""] "selection.data(array)"

enter :: forall d. Update d -> D3Eff (Enter d)
enter = ffi ["update", ""] "update.enter()"

exit :: forall d. Update d -> D3Eff (Exit d)
exit = ffi ["update", ""] "update.exit()"

transition :: forall d. Selection d -> D3Eff (Transition d)
transition = ffi ["selection", ""] "selection.transition()"

unsafeAppend :: forall x y. String -> x -> D3Eff y
unsafeAppend = ffi ["tag", "selection", ""] "selection.append(tag)"

unsafeRemove :: forall s. s -> D3Eff Unit
unsafeRemove = ffi ["selection", ""] "selection.remove()"

unsafeAttr :: forall d v s. (AttrValue v) => String -> v -> s -> D3Eff s
unsafeAttr = ffi ["key", "val", "selection", ""] "selection.attr(key, val)"

unsafeAttr' :: forall d v s. (AttrValue v) => String -> (d -> v) -> s -> D3Eff s
unsafeAttr' = ffi ["key", "val", "selection", ""] "selection.attr(key, val)"

unsafeAttr'' :: forall d v s. (AttrValue v) => String -> (d -> Number -> v) -> s -> D3Eff s
unsafeAttr'' = ffi
  ["key", "val", "selection", ""]
  "selection.attr(key, function (d, i) { return val(d)(i); })"

unsafeStyle :: forall d s. String -> String -> s -> D3Eff s
unsafeStyle = ffi ["key", "val", "selection", ""] "selection.style(key, val)"

unsafeStyle' :: forall d s. String -> (d -> String) -> s -> D3Eff s
unsafeStyle' = ffi ["key", "val", "selection", ""] "selection.style(key, val)"

unsafeStyle'' :: forall d s. String -> (d -> Number -> String) -> s -> D3Eff s
unsafeStyle'' = ffi
  ["key", "val", "selection", ""]
  "selection.style(key, function (d, i) { return val(d)(i); })"

unsafeText :: forall d s. String -> s -> D3Eff s
unsafeText = ffi ["text", "selection", ""] "selection.text(text)"

unsafeText' :: forall d s. (d -> String) -> s -> D3Eff s
unsafeText' = ffi ["text", "selection", ""] "selection.text(text)"

unsafeText'' :: forall d s. (d -> Number -> String) -> s -> D3Eff s
unsafeText'' = ffi
  ["text", "selection", ""] 
  "selection.text(function (d, i) { return text(d)(i); })"

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
  attr :: forall d v. (AttrValue v) => String -> v -> s d -> D3Eff (s d)
  attr' :: forall d v. (AttrValue v) => String -> (d -> v) -> s d -> D3Eff (s d)
  attr'' :: forall d v. (AttrValue v) => String -> (d -> Number -> v) -> s d -> D3Eff (s d)
  style :: forall d. String -> String -> s d -> D3Eff (s d)
  style' :: forall d. String -> (d -> String) -> s d -> D3Eff (s d)
  style'' :: forall d. String -> (d -> Number -> String) -> s d -> D3Eff (s d)
  text :: forall d. String -> s d -> D3Eff (s d)
  text' :: forall d. (d -> String) -> s d -> D3Eff (s d)
  text'' :: forall d. (d -> Number -> String) -> s d -> D3Eff (s d)
  remove :: forall d. s d -> D3Eff Unit

instance existingSelection :: Existing Selection where
  attr = unsafeAttr
  attr' = unsafeAttr'
  attr'' = unsafeAttr''
  style = unsafeStyle
  style' = unsafeStyle'
  style'' = unsafeStyle''
  text = unsafeText
  text' = unsafeText'
  text'' = unsafeText''
  remove = unsafeRemove

instance existingUpdate :: Existing Update where
  attr = unsafeAttr
  attr' = unsafeAttr'
  attr'' = unsafeAttr''
  style = unsafeStyle
  style' = unsafeStyle'
  style'' = unsafeStyle''
  text = unsafeText
  text' = unsafeText'
  text'' = unsafeText''
  remove = unsafeRemove

instance existingTransition :: Existing Transition where
  attr = unsafeAttr
  attr' = unsafeAttr'
  attr'' = unsafeAttr''
  style = unsafeStyle
  style' = unsafeStyle'
  style'' = unsafeStyle''
  text = unsafeText
  text' = unsafeText'
  text'' = unsafeText''
  remove = unsafeRemove
