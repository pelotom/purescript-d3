module Graphics.D3.Layout.Force
  ( ForceLayout(..)
  , forceLayout
  , linkDistance
  , linkStrength
  , friction
  , charge
  , chargeDistance
  , theta
  , gravity
  , start
  , alpha
  , resume
  , stop
  , tick
  , drag
  , onDragStart
  , onTick
  , createDrag
  ) where

import Effect (Effect)
import Foreign (Foreign)

import Graphics.D3.Base (D3Eff)
import Graphics.D3.Selection (Selection)
import Graphics.D3.Layout.Base
import Graphics.D3.Util (ffi)

foreign import data ForceLayout :: Type

foreign import forceLayout :: D3Eff ForceLayout

instance forceGraphLayout :: GraphLayout ForceLayout where
  size dims = ffi ["w", "h", "force", ""] "force.size([w, h])" dims.width dims.height
  nodes = ffi ["nodes", "force", ""] "force.nodes(nodes)"
  links = ffi ["links", "force", ""] "force.links(links)"

linkDistance :: Number -> ForceLayout -> D3Eff ForceLayout
linkDistance = ffi ["distance", "force", ""] "force.linkDistance(distance)"

linkStrength :: Number -> ForceLayout -> D3Eff ForceLayout
linkStrength = ffi ["strength", "force", ""] "force.linkStrength(strength)"

friction :: Number -> ForceLayout -> D3Eff ForceLayout
friction = ffi ["friction", "force", ""] "force.friction(friction)" 

charge :: Number -> ForceLayout -> D3Eff ForceLayout
charge = ffi ["charge", "force", ""] "force.charge(charge)"

chargeDistance :: Number -> ForceLayout -> D3Eff ForceLayout
chargeDistance = ffi ["distance", "force", ""] "force.chargeDistance(distance)"

theta :: Number -> ForceLayout -> D3Eff ForceLayout
theta = ffi ["theta", "force", ""] "force.theta(theta)"

gravity :: Number -> ForceLayout -> D3Eff ForceLayout
gravity = ffi ["gravity", "force", ""] "force.gravity(gravity)"

start :: ForceLayout -> D3Eff ForceLayout
start = ffi ["force", ""] "force.start()"

alpha :: Number -> ForceLayout -> D3Eff ForceLayout
alpha = ffi ["alpha", "force", ""] "force.alpha(alpha)"

resume :: ForceLayout -> D3Eff ForceLayout
resume = ffi ["force", ""] "force.resume()"

stop :: ForceLayout -> D3Eff ForceLayout
stop = ffi ["force", ""] "force.stop()"

tick :: ForceLayout -> D3Eff ForceLayout
tick = ffi ["force", ""] "force.tick()"

onTick :: forall r. (Foreign -> Effect r) -> ForceLayout -> D3Eff ForceLayout
onTick = ffi
  ["callback", "force", ""]
  "force.on('tick', function (d) { return callback(d)(); })"

onDragStart :: forall r. (Foreign -> Effect r) -> ForceLayout -> D3Eff ForceLayout
onDragStart = ffi ["callback", "force", ""] "force.on('dragstart', callback)"

drag :: ForceLayout -> D3Eff ForceLayout
drag = ffi ["force", ""] "force.drag()"

createDrag :: forall s. ForceLayout -> Selection s -> D3Eff (Selection s)
createDrag = ffi ["obj", "callable", ""] "callable.call(obj);"
