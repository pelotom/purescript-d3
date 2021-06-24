module Graphics.D3.Link
  ( class Link
  , LinkVertical()
  , LinkHorizontal()
  , linkVertical
  , linkHorizontal
  , source
  , target
  , x
  , y
  ) where

import Data.Function.Uncurried (Fn1, runFn1)
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception.Unsafe (unsafeThrow)
import Effect.Uncurried (EffectFn1, runEffectFn1)

import Prelude ( ($), (>>=), pure, bind )

import Graphics.D3.Base (d3, D3, D3Eff)
import Graphics.D3.Interpolate (Interpolator)
import Graphics.D3.Selection as Selection
import Graphics.D3.Unsafe (unsafeToFunction, unsafeCopy, unsafeRange, unsafeDomain)
import Graphics.D3.Util (ffi)

-- Link is of type
-- s sd td
-- d : main data type
-- sd : source data type
-- td : target data type

class Link s where
  source :: forall d sd td. (d -> sd) -> s d sd td -> D3Eff (s d sd td)
  target :: forall d sd td. (d -> td) -> s d sd td -> D3Eff (s d sd td)
  x :: forall d sd td. (sd -> Number) -> s d sd td -> D3Eff (s d sd td)
  y :: forall d sd td. (td -> Number) -> s d sd td -> D3Eff (s d sd td)
  -- context

-- Link types

foreign import data LinkVertical   :: Type -> Type -> Type -> Type
foreign import data LinkHorizontal :: Type -> Type -> Type -> Type

instance attrValueLinkHorizontal :: Selection.AttrValue (LinkHorizontal d sd td)
instance attrValueLinkVertical   :: Selection.AttrValue (LinkVertical d sd td)

-- Scale constructors

foreign import linkVerticalImpl :: forall d sd td. Fn1 D3 (D3Eff (LinkVertical d sd td))
foreign import linkHorizontalImpl :: forall d sd td. Fn1 D3 (D3Eff (LinkHorizontal d sd td))

linkVertical   :: forall d sd td. D3Eff (LinkVertical d sd td)
linkVertical   = runFn1 linkVerticalImpl d3
linkHorizontal :: forall d sd td. D3Eff (LinkHorizontal d sd td)
linkHorizontal = runFn1 linkHorizontalImpl d3

-- Link class instances

instance linkLinkVertical :: Link LinkVertical where
  source = unsafeSource
  target = unsafeTarget
  x = unsafeX
  y = unsafeY

instance linkLinkHorizontal :: Link LinkHorizontal where
  source = unsafeSource
  target = unsafeTarget
  x = unsafeX
  y = unsafeY

unsafeSource = ffi ["func", "link", ""] "link.source(func)"
unsafeTarget = ffi ["func", "link", ""] "link.target(func)"
unsafeX = ffi ["func", "link", ""] "link.x(func)"
unsafeY = ffi ["func", "link", ""] "link.y(func)"
