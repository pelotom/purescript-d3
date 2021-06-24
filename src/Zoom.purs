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

import Data.Function.Uncurried (Fn2, runFn2)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1, EffectFn2, runEffectFn2, EffectFn3, runEffectFn3)

import Graphics.D3.Base (d3, D3, D3Eff)
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

foreign import zoomImpl :: EffectFn1 D3 Zoom

zoom :: D3Eff Zoom
zoom = runEffectFn1 zoomImpl d3
-- zoom = ffiD3 [""] "d3.zoom()"

zoomIdentity :: Zoom
zoomIdentity = ffiD3 [""] "d3.zoomIdentity"

foreign import onImpl :: forall e. EffectFn3 String (ZoomE -> Effect e) Zoom Zoom

on :: forall e. String -> (ZoomE -> Effect e) -> Zoom -> D3Eff Zoom
on = runEffectFn3 onImpl

foreign import renderZoomImpl :: forall s d. EffectFn2 Zoom (s d) (Selection.Selection d)

renderZoom :: forall s d. (Selection.Existing s) => Zoom -> s d -> D3Eff (Selection.Selection d)
renderZoom = runEffectFn2 renderZoomImpl
-- renderZoom = ffi ["selection", "zoom", ""] "selection.call(zoom)"

unsafeTransform :: forall a. a -> Transform
unsafeTransform = ffi ["obj"] "obj.transform"
