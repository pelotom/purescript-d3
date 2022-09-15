module Graphics.D3.Selection
  ( Selection()
  , Update()
  , Enter()
  , Exit()
  , Transition()
  , Void()
  , class AttrValue
  , class Existing
  , class Callable
  , class Appendable
  , class Joinable
  , class Classed
  , class Clickable
  , rootSelect
  , rootSelectAll
  , rootSelectEl
  , select
  , selectAll
  , bindData
  , enter
  , exit
  , transition
  , call
  , append
  , combineAppend
  , (>=>++)
  , join
  , classed
  , remove
  , attr
  , combineAttr
  , (>=>)
  , combineAttr'
  , (>=>-)
  , attr'
  , attr''
  , style
  , style'
  , style''
  , text
  , text'
  , text''
  , delay
  , delay'
  , delay''
  , duration
  , duration'
  , duration''
  , onClick
  , onDoubleClick
  ) where

import Data.Tuple (Tuple(..))
import DOM.Simple (Element)
import Effect (Effect)
import Foreign (Foreign)

import Prelude ( Unit(), (>>=) )

import Graphics.D3.Base (D3Eff)
import Graphics.D3.Util (ffi, ffiD3)

-- The "selection-y" types, parameterized by the type of their bound data
foreign import data Selection :: Type -> Type
foreign import data Update :: Type -> Type
foreign import data Enter :: Type -> Type
foreign import data Transition :: Type -> Type

-- Exit selections have the same semantics as regular selections
type Exit d = Selection d

-- The (uninhabited) type of an unbound selection's data
data Void

-- The class of types which element attribute values can have (numbers and strings)
class AttrValue :: forall k. k -> Constraint
class AttrValue a

instance attrValInt :: AttrValue Int
instance attrValNumber :: AttrValue Number
instance attrValString :: AttrValue String

rootSelect :: String -> D3Eff (Selection Void)
rootSelect = ffiD3 ["selector", ""] "d3.select(selector)"

rootSelectAll :: String -> D3Eff (Selection Void)
rootSelectAll = ffiD3 ["selector", ""] "d3.selectAll(selector)"

rootSelectEl :: Element -> D3Eff (Selection Void)
rootSelectEl = ffi ["node", ""] "d3.select(node)"

select :: forall d. String -> Selection d -> D3Eff (Selection d)
select = ffi ["selector", "selection", ""] "selection.select(selector)"

selectAll :: forall d. String -> Selection d -> D3Eff (Selection Void)
selectAll = ffi ["selector", "selection", ""] "selection.selectAll(selector)"

bindData :: forall oldData newData. Array newData -> Selection oldData -> D3Eff (Update newData)
bindData = ffi ["array", "selection", ""] "selection.data(array)"

enter :: forall d. Update d -> D3Eff (Enter d)
enter = ffi ["update", ""] "update.enter()"

exit :: forall d. Update d -> D3Eff (Exit d)
exit = ffi ["update", ""] "update.exit()"

transition :: forall s d. (Existing s) => s d -> D3Eff (Transition d)
transition = ffi ["selection", ""] "selection.transition()"

unsafeCall :: forall a b x y. a -> b -> x -> D3Eff y
unsafeCall = ffi ["what", "func", "selection", ""] "selection.call(what, func)"

unsafeAppend :: forall x y. String -> x -> D3Eff y
unsafeAppend = ffi ["tag", "selection", ""] "selection.append(tag)"

unsafeJoin :: forall x y. String -> x -> D3Eff y
unsafeJoin = ffi ["tag", "selection", ""] "selection.join(tag)"

unsafeClassed :: forall x y. String -> Boolean -> x -> D3Eff y
unsafeClassed = ffi ["tag", "value", "selection", ""] "selection.classed(tag, value)"

unsafeRemove :: forall s. s -> D3Eff Unit
unsafeRemove = ffi ["selection", ""] "selection.remove()"

unsafeAttr :: forall v s. (AttrValue v) => String -> v -> s -> D3Eff s
unsafeAttr = ffi ["key", "val", "selection", ""] "selection.attr(key, val)"

unsafeAttr' :: forall d v s. (AttrValue v) => String -> (d -> v) -> s -> D3Eff s
unsafeAttr' = ffi ["key", "val", "selection", ""] "selection.attr(key, val)"

unsafeAttr'' :: forall d v s. (AttrValue v) => String -> (d -> Number -> v) -> s -> D3Eff s
unsafeAttr'' = ffi
  ["key", "val", "selection", ""]
  "selection.attr(key, function (d, i) { return val(d)(i); })"

unsafeStyle :: forall s. String -> String -> s -> D3Eff s
unsafeStyle = ffi ["key", "val", "selection", ""] "selection.style(key, val)"

unsafeStyle' :: forall d s. String -> (d -> String) -> s -> D3Eff s
unsafeStyle' = ffi ["key", "val", "selection", ""] "selection.style(key, val)"

unsafeStyle'' :: forall d s. String -> (d -> Number -> String) -> s -> D3Eff s
unsafeStyle'' = ffi
  ["key", "val", "selection", ""]
  "selection.style(key, function (d, i) { return val(d)(i); })"

unsafeText :: forall s. String -> s -> D3Eff s
unsafeText = ffi ["text", "selection", ""] "selection.text(text)"

unsafeText' :: forall d s. (d -> String) -> s -> D3Eff s
unsafeText' = ffi ["text", "selection", ""] "selection.text(text)"

unsafeText'' :: forall d s. (d -> Number -> String) -> s -> D3Eff s
unsafeText'' = ffi
  ["text", "selection", ""]
  "selection.text(function (d, i) { return text(d)(i); })"

unsafeOnClick :: forall c i r. (Clickable c) => (i -> Effect r) -> c -> D3Eff c
unsafeOnClick = ffi ["callback", "clickable", ""] "clickable.on('click', function(data) { callback(data)(); })"

unsafeOnDoubleClick :: forall c i r. (Clickable c) => (i -> Effect r) -> c -> D3Eff c
unsafeOnDoubleClick = ffi ["callback", "clickable", ""] "clickable.on('dblclick', function (data) { callback(data)(); })"

-- Transition-only stuff
delay :: forall d. Number -> Transition d -> D3Eff (Transition d)
delay = ffi ["delay", "transition", ""] "transition.delay(delay)"

delay' :: forall d. (d -> Number) -> Transition d -> D3Eff (Transition d)
delay' = ffi ["delay", "transition", ""] "transition.delay(delay)"

delay'' :: forall d. (d -> Number -> Number) -> Transition d -> D3Eff (Transition d)
delay'' = ffi
  ["delay", "transition", ""]
  "transition.delay(function (d, i) { return delay(d)(i); })"

duration :: forall d. Number -> Transition d -> D3Eff (Transition d)
duration = ffi ["duration", "transition", ""] "transition.duration(duration)"

duration' :: forall d. (d -> Number) -> Transition d -> D3Eff (Transition d)
duration' = ffi ["duration", "transition", ""] "transition.duration(duration)"

duration'' :: forall d. (d -> Number -> Number) -> Transition d -> D3Eff (Transition d)
duration'' = ffi
  ["duration", "transition", ""]
  "transition.duration(function (d, i) { return duration(d)(i); })"

-- Callable

class Callable s where
  call :: forall a b d. a -> b -> s d -> D3Eff (Selection d)

instance callableSelection  :: Callable Selection where
  call = unsafeCall

instance callableUpdate     :: Callable Update where
  call = unsafeCall

instance callableEnter      :: Callable Enter where
  call = unsafeCall

-- Selection-y things which can be appended to / inserted into
class Appendable s where
  append :: forall d. String -> s d -> D3Eff (Selection d)

instance appendableSelection  :: Appendable Selection where
  append = unsafeAppend

instance appendableUpdate     :: Appendable Update where
  append = unsafeAppend

instance appendableEnter      :: Appendable Enter where
  append = unsafeAppend

combineAppend m g = m >>= append g

infixl 1 combineAppend as >=>++

-- Selection-y things which can be joined
class Joinable s where
  join :: forall d. String -> s d -> D3Eff (Selection d)

instance joinableSelection  :: Joinable Selection where
  join = unsafeJoin

instance joinableUpdate     :: Joinable Update where
  join = unsafeJoin

instance joinableEnter      :: Joinable Enter where
  join = unsafeJoin

-- Selection-y things which can be classed
class Classed s where
  classed :: forall d. String -> Boolean -> s d -> D3Eff (Selection d)

instance classedSelection  :: Classed Selection where
  classed = unsafeClassed

instance classedUpdate     :: Classed Update where
  classed = unsafeClassed

instance classedEnter      :: Classed Enter where
  classed = unsafeClassed

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

combineAttr :: forall s k v. Existing s => AttrValue v => D3Eff (s k) -> Tuple String v -> D3Eff (s k)
combineAttr m (Tuple k v) = m >>= attr k v

combineAttr' m (Tuple k v') = m >>= attr' k v'

infixl 1 combineAttr as >=>
infixl 1 combineAttr' as >=>-

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

class Clickable c where
  onClick :: forall r. (Foreign -> Effect r) -> c -> D3Eff c
  onDoubleClick :: forall r. (Foreign -> Effect r) -> c -> D3Eff c

instance clickableSelection :: Clickable (Selection a) where
  -- NOTE: psc complains about cycles unless onclick/onDoubleClick are inlined
  onClick = ffi ["callback", "clickable", ""] "clickable.on('click', function(data) { callback(data)(); })"
  onDoubleClick = ffi ["callback", "clickable", ""] "clickable.on('dblclick', function (data) { callback(data)(); })"
