module Graphics.D3.Contour
  ( class Contour
  , ContourDensity()
  , contourDensity
  , x
  , x'
  , y
  , y'
  , size
  , bandwidth
  , toFunction
  , GeoPath()
  , geoPath
  ) where

import Data.Function.Uncurried (Fn1, runFn1)
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception.Unsafe (unsafeThrow)
import Effect.Uncurried (EffectFn1, runEffectFn1)

import Prelude ( ($), (>>=), pure, bind )

import Graphics.D3.Base (d3, D3, D3Eff)
import Graphics.D3.Selection as Selection
import Graphics.D3.Unsafe (unsafeToFunction)
import Graphics.D3.Util (ffi)

-- A base class for all contour types

-- Type of Contour is:
-- s od nd b size
-- i.e. old-data, new-data, bandwidth, size
-- old-data is the data that is sent to x, y functions
-- new-data is the data produced by toFunction

class Contour s where
  x :: forall od nd b size. String -> s od nd b size -> D3Eff (s od nd b size)
  x' :: forall od nd b size. (od -> Number) -> s od nd b size -> D3Eff (s od nd b size)
  y :: forall od nd b size. String -> s od nd b size -> D3Eff (s od nd b size)
  y' :: forall od nd b size. (od -> Number) -> s od nd b size -> D3Eff (s od nd b size)
  size :: forall od nd b size. Array size -> s od nd b size -> D3Eff (s od nd b size)
  bandwidth :: forall od nd b size. b -> s od nd b size -> D3Eff (s od nd b size)
  toFunction :: forall od nd b size. s od nd b size -> D3Eff (Array od -> Array nd)

-- Contour types

foreign import data ContourDensity :: Type -> Type -> Type -> Type -> Type

-- Scale constructors

foreign import contourDensityImpl :: forall d. Fn1 D3 (D3Eff (ContourDensity d Number Number Number))

contourDensity :: forall d. D3Eff (ContourDensity d Number Number Number)
contourDensity = runFn1 contourDensityImpl d3

-- Contour class instances

instance contourDensityContour :: Contour ContourDensity where
  x = unsafeX
  x' = unsafeX'
  y = unsafeY
  y' = unsafeY'
  size = unsafeSize
  bandwidth = unsafeBandwidth
  toFunction = ffi ["density", ""] "density"

unsafeX :: forall s. String -> s -> D3Eff s
unsafeX = ffi ["func", "contour", ""] "contour.x(func)"
unsafeX' :: forall s d. (d -> Number) -> s -> D3Eff s
unsafeX' = ffi ["func", "contour", ""] "contour.x(func)"
unsafeY :: forall s. String -> s -> D3Eff s
unsafeY = ffi ["func", "contour", ""] "contour.y(func)"
unsafeY' :: forall s d. (d -> Number) -> s -> D3Eff s
unsafeY' = ffi ["func", "contour", ""] "contour.y(func)"
unsafeSize = ffi ["values", "contour", ""] "contour.size(values)"
unsafeBandwidth = ffi ["value", "contour", ""] "contour.bandwidth(value)"

foreign import data GeoPath :: Type

foreign import geoPathImpl :: Fn1 D3 GeoPath

geoPath :: GeoPath
geoPath = runFn1 geoPathImpl d3

instance attrValGeoPath :: Selection.AttrValue GeoPath
