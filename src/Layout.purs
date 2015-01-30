module Graphics.D3.Layout
  ( ForceLayout(..)
  , Layout
  , forceLayout
  , size
  , charge
  , linkDistance
  , nodes
  , links
  , drag
  , onDragStart
  , start
  , onTick
  , createDrag
  ) where

import Control.Monad.Eff
import Data.Foreign
import Data.Foreign.EasyFFI

import Graphics.D3.Base
import Graphics.D3.Selection
import Graphics.D3.Util

ffi = unsafeForeignFunction

foreign import data ForceLayout :: *

foreign import forceLayout "var forceLayout = d3.layout.force" :: D3Eff ForceLayout

class Layout l where
  size :: forall d. { width :: Number, height :: Number | d } -> l -> D3Eff l
  nodes :: forall a. [a] -> l -> D3Eff l
  links :: forall a. [a] -> l -> D3Eff l

instance layoutForceLayout :: Layout ForceLayout where
  size = unsafeSize
  nodes = unsafeNodes
  links = unsafeLinks

unsafeSize :: forall d l. (Layout l) => { width :: Number, height :: Number | d } -> l -> D3Eff l
unsafeSize dimensions = f dimensions.width dimensions.height
  where f = ffi ["width", "height", "layout", ""] "layout.size([width, height])"

unsafeNodes :: forall a l. (Layout l) => [a] -> l -> D3Eff l
unsafeNodes = ffi ["nodes", "graph", ""] "graph.nodes(nodes)"

unsafeLinks :: forall a l. (Layout l) => [a] -> l -> D3Eff l
unsafeLinks = ffi ["links", "graph", ""] "graph.links(links)"

charge :: Number -> ForceLayout -> D3Eff ForceLayout
charge = ffi ["charge", "forced", ""] "forced.charge(charge)"

linkDistance :: Number -> ForceLayout -> D3Eff ForceLayout
linkDistance = ffi ["distance", "forced", ""] "forced.linkDistance(distance)"

onTick :: forall eff r. (Foreign -> Eff eff r) -> ForceLayout -> D3Eff ForceLayout
onTick = ffi
  ["callback", "ticking", ""]
  "ticking.on(\"tick\", function (d) { return callback(d)(); })"

drag :: ForceLayout -> D3Eff ForceLayout
drag = ffi ["draggable", ""] "draggable.drag()"

onDragStart :: forall eff r. (Foreign -> Eff eff r) -> ForceLayout -> D3Eff ForceLayout
onDragStart = ffi ["callback", "draggable", ""] "draggable.on(\"dragstart\", callback)"

start :: ForceLayout -> D3Eff ForceLayout
start = ffi ["draggable", ""] "draggable.start()"

createDrag :: forall s. ForceLayout -> Selection s -> D3Eff (Selection s)
createDrag = ffi ["obj", "callable", ""] "callable.call(obj);"
