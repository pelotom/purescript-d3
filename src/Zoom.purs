module Graphics.D3.Zoom
  ( Zoom()
  , Transform()
  , ZoomE()
  , class ZoomEvent
  , transform
  , zoom
  , on
  , renderZoom
  ) where

import Effect.Uncurried (EffectFn1, EffectFn3, runEffectFn3)


import Graphics.D3.Base (D3, D3Eff)
import Graphics.D3.Selection as Selection
import Graphics.D3.Util (ffi, ffiD3)

foreign import data Zoom :: Type
foreign import data ZoomE :: Type
foreign import data Transform :: Type

foreign import zoomImpl :: EffectFn1 D3 Zoom

instance attrValueTransform :: Selection.AttrValue Transform

class ZoomEvent s where
  transform :: s -> Transform

instance ZoomEvent ZoomE where
  transform = unsafeTransform

zoom :: D3Eff Zoom
zoom = ffiD3 [""] "d3.zoom()"

foreign import onImpl :: forall e. EffectFn3 String (ZoomE -> e) Zoom Zoom

on :: forall e. String -> (ZoomE -> e) -> Zoom -> D3Eff Zoom
on = runEffectFn3 onImpl

renderZoom :: forall s d. (Selection.Existing s) => Zoom -> s d -> D3Eff (Selection.Selection d)
renderZoom = ffi ["zoom", "selection", ""] "selection.call(zoom)"

unsafeTransform :: ZoomE -> Transform
unsafeTransform = ffi ["zoomEvent"] "zoomEvent.transform"
