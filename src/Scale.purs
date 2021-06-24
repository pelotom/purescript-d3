module Graphics.D3.Scale
  ( class Scale
  , class Quantitative
  , LinearScale()
  , PowerScale()
  , LogScale()
  , QuantizeScale()
  , QuantileScale()
  , ThresholdScale()
  , OrdinalScale()
  , linearScale
  , powerScale
  , sqrtScale
  , logScale
  , quantizeScale
  , quantileScale
  , thresholdScale
  , ordinalScale
  , domain
  , range
  , copy
  , toFunction
  , invert
  , rangeRound
  , interpolate
  , clamp
  , nice
  , getTicks
  , getTickFormat
  , exponent
  , base
  , rangePoints
  , rangeBands
  , rangeRoundBands
  , rangeBand
  , rangeExtent
  ) where

import Data.Function.Uncurried (Fn1, runFn1)
import Data.Tuple (Tuple(..))
import Data.Maybe (Maybe(..))
import Effect.Exception.Unsafe (unsafeThrow)

import Prelude (bind, pure, ($))

import Graphics.D3.Base (d3, D3, D3Eff)
import Graphics.D3.Interpolate (Interpolator)
import Graphics.D3.Unsafe (unsafeToFunction, unsafeCopy, unsafeRange, unsafeDomain)
import Graphics.D3.Util (ffi)

-- A base class for all scale types

class Scale s where
  domain :: forall d r. Array d -> s d r -> D3Eff (s d r)
  range :: forall d r. Array r -> s d r -> D3Eff (s d r)
  copy :: forall d r. s d r -> D3Eff (s d r)
  toFunction :: forall d r. s d r -> D3Eff (d -> r)

-- Quantitative (numeric domain) scales

class Quantitative s where
  invert :: s Number Number -> D3Eff (Number -> Number)
  rangeRound :: Array Number -> s Number Number -> D3Eff (s Number Number)
  interpolate :: forall r. Interpolator r -> s Number r -> D3Eff (s Number r)
  clamp :: forall r. Boolean -> s Number r -> D3Eff (s Number r)
  nice :: forall r. Maybe Number -> s Number r -> D3Eff (s Number r)
  getTicks :: forall r. Maybe Number -> s Number r -> D3Eff (Array Number)
  getTickFormat :: forall r. Number -> Maybe String -> s Number r -> D3Eff (Number -> String)

-- Scale types

foreign import data LinearScale :: Type -> Type -> Type
foreign import data IdentityScale :: Type -> Type -> Type
foreign import data PowerScale :: Type -> Type -> Type
foreign import data LogScale :: Type -> Type -> Type
foreign import data QuantizeScale :: Type -> Type -> Type
foreign import data QuantileScale :: Type -> Type -> Type
foreign import data ThresholdScale :: Type -> Type -> Type
foreign import data OrdinalScale :: Type -> Type -> Type

-- Scale constructors

foreign import linearScaleImpl    :: forall r. Fn1 D3 (D3Eff (LinearScale Number r))
foreign import powerScaleImpl     :: forall r. Fn1 D3 (D3Eff (PowerScale Number r))
foreign import sqrtScaleImpl      :: forall r. Fn1 D3 (D3Eff (PowerScale Number r))
foreign import logScaleImpl       :: forall r. Fn1 D3 (D3Eff (LogScale Number r))
foreign import quantizeScaleImpl  :: forall r. Fn1 D3 (D3Eff (QuantizeScale Number r))
foreign import quantileScaleImpl  :: forall r. Fn1 D3 (D3Eff (QuantileScale Number r))
foreign import thresholdScaleImpl :: forall r. Fn1 D3 (D3Eff (ThresholdScale Number r))
foreign import ordinalScaleImpl   :: forall d r. Fn1 D3 (D3Eff (OrdinalScale d r))

linearScale    :: forall r. D3Eff (LinearScale Number r)
linearScale    = runFn1 linearScaleImpl d3
powerScale     :: forall r. D3Eff (PowerScale Number r)
powerScale     = runFn1 powerScaleImpl d3
sqrtScale      :: forall r. D3Eff (PowerScale Number r)
sqrtScale      = runFn1 sqrtScaleImpl d3
logScale       :: forall r. D3Eff (LogScale Number r)
logScale       = runFn1 logScaleImpl d3
quantizeScale  :: forall r. D3Eff (QuantizeScale Number r)
quantizeScale  = runFn1 quantizeScaleImpl d3
quantileScale  :: forall r. D3Eff (QuantileScale Number r)
quantileScale  = runFn1 quantileScaleImpl d3
thresholdScale :: forall r. D3Eff (ThresholdScale Number r)
thresholdScale = runFn1 thresholdScaleImpl d3
ordinalScale   :: forall d r. D3Eff (OrdinalScale d r)
ordinalScale   = runFn1 ordinalScaleImpl d3

-- Power scale methods

exponent :: forall r. Number -> PowerScale Number r -> D3Eff (PowerScale Number r)
exponent = ffi ["k", "scale", ""] "scale.exponent(k)"

-- Log scale methods

base :: forall r. Number -> LogScale Number r -> D3Eff (LogScale Number r)
base = ffi ["base", "scale", ""] "scale.base(base)"

-- Quantile scale methods

quantiles :: forall r. QuantileScale Number r -> D3Eff (QuantileScale Number r)
quantiles = ffi ["scale", ""] "scale.quantiles()"

-- Ordinal scale methods

rangePoints :: forall d. Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
rangePoints = ffi
  ["min", "max", "padding", "scale", ""]
  "scale.rangePoints([min, max], padding)"

rangeBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
rangeBands = ffi
  ["min", "max", "padding", "outerPadding", "scale", ""]
  "scale.rangeBands([min, max], padding, outerPadding)"

rangeRoundBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
rangeRoundBands = ffi
  ["min", "max", "padding", "outerPadding", "scale", ""]
  "scale.rangeRoundBands([min, max], padding, outerPadding)"

rangeBand :: forall d. OrdinalScale d Number -> D3Eff Number
rangeBand = ffi ["scale"] "scale.rangeBand"

rangeExtent :: forall d. OrdinalScale d Number -> D3Eff (Tuple Number Number)
rangeExtent scale = do
  rng <- ffi ["scale"] "scale.rangeExtent" scale
  case rng of
       [min, max] -> pure $ Tuple min max
       _          -> unsafeThrow "scale function returned more or less than 2 elements"

-- Scale class instances

instance scaleLinear :: Scale LinearScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

instance quantitativeLinear :: Quantitative LinearScale where
  invert = unsafeInvert
  rangeRound = unsafeRangeRound
  interpolate = unsafeInterpolate
  clamp = unsafeClamp
  nice = unsafeNice
  getTicks = unsafeTicks
  getTickFormat = unsafeTickFormat

instance scalePower :: Scale PowerScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

instance quantitativePower :: Quantitative PowerScale where
  invert = unsafeInvert
  rangeRound = unsafeRangeRound
  interpolate = unsafeInterpolate
  clamp = unsafeClamp
  nice = unsafeNice
  getTicks = unsafeTicks
  getTickFormat = unsafeTickFormat

instance scaleLog :: Scale LogScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

instance quantitativeLog :: Quantitative LogScale where
  invert = unsafeInvert
  rangeRound = unsafeRangeRound
  interpolate = unsafeInterpolate
  clamp = unsafeClamp
  nice = unsafeNice
  getTicks = unsafeTicks
  getTickFormat = unsafeTickFormat

instance scaleQuantize :: Scale QuantizeScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

instance scaleQuantile :: Scale QuantileScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

instance scaleThreshold :: Scale ThresholdScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

instance scaleOrdinal :: Scale OrdinalScale where
  domain = unsafeDomain
  range = unsafeRange
  copy = unsafeCopy
  toFunction = unsafeToFunction

unsafeInvert :: forall t101. t101
unsafeInvert = ffi ["scale", ""] "scale.copy().invert"
unsafeRangeRound :: forall t91. t91
unsafeRangeRound = ffi ["values", "scale", ""] "scale.rangeRound(values)"
unsafeInterpolate :: forall t103. t103
unsafeInterpolate = ffi ["factory", "scale", ""] "scale.interpolate(factory)"
unsafeClamp :: forall t105. t105
unsafeClamp = ffi ["bool", "scale", ""] "scale.clamp(bool)"
unsafeNice :: forall t94 t95. Maybe t95 -> t94
unsafeNice count = case count of
  Nothing -> ffi ["scale", ""] "scale.nice()"
  Just c -> ffi ["count", "scale", ""] "scale.nice(count)" c
unsafeTicks :: forall t73 t74. Maybe t74 -> t73
unsafeTicks count = case count of
  Nothing -> ffi ["scale", ""] "scale.ticks()"
  Just c -> ffi ["count", "scale", ""] "scale.ticks(count)" c
unsafeTickFormat :: forall t80 t82 t83. t80 -> Maybe t83 -> t82
unsafeTickFormat count format = case format of
  Nothing -> ffi ["count", "scale", ""] "scale.tickFormat(count)" count
  Just f -> ffi ["count", "format", "scale", ""] "scale.tickFormat(count, format)" count f
