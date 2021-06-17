module Graphics.D3.Zoom
  ( Zoom()
  , Transform()
  , ZoomE()
  , class Transformable
  , transform
  , zoom
  , zoomIdentity
  , on
  , renderZoom
  ) where

import Effect.Uncurried (EffectFn3, runEffectFn3)

import Graphics.D3.Base (D3Eff)
import Graphics.D3.Selection as Selection
import Graphics.D3.Util (ffi, ffiD3)

foreign import data Zoom :: Type
foreign import data ZoomE :: Type
foreign import data Transform :: Type

instance attrValueTransform :: Selection.AttrValue Transform

class Transformable s where
  transform :: s -> Transform

instance Transformable ZoomE where
  transform = unsafeTransform

instance Transformable Zoom where
  transform = unsafeTransform

zoom :: D3Eff Zoom
zoom = ffiD3 [""] "d3.zoom()"

zoomIdentity :: Zoom
zoomIdentity = ffiD3 [""] "d3.zoomIdentity"

foreign import onImpl :: forall e. EffectFn3 String (ZoomE -> e) Zoom Zoom

on :: forall e. String -> (ZoomE -> e) -> Zoom -> D3Eff Zoom
on = runEffectFn3 onImpl

renderZoom :: forall s d. (Selection.Existing s) => Zoom -> s d -> D3Eff (Selection.Selection d)
renderZoom = ffi ["zoom", "selection", ""] "selection.call(zoom)"

unsafeTransform :: forall a. a -> Transform
unsafeTransform = ffi ["obj"] "obj.transform"
