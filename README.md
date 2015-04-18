# purescript-d3

### Example

Here is the JavaScript code from [part 1](http://bl.ocks.org/mbostock/7322386) of Mike Bostock's [Let's Make a Bar Chart](http://bost.ocks.org/mike/bar/) series of tutorials for D3:

```javascript
var data = [4, 8, 15, 16, 23, 42];

var x = d3.scale.linear()
  .domain([0, d3.max(data)])
  .range([0, 420]);

d3.select(".chart")
  .selectAll("div")
    .data(data)
  .enter().append("div")
    .style("width", function(d) { return x(d) + "px"; })
    .text(function(d) { return d; });
```

And here is the PureScript equivalent:

```haskell
array = [4, 8, 15, 16, 23, 42]

main = do

  x <- linearScale
    .. domain [0, max id array]
    .. range [0, 420]
    .. toFunction

  rootSelect ".chart"
    .. selectAll "div"
      .. bind array
    .. enter .. append "div"
      .. style' "width" (\d -> show (x d) ++ "px")
      .. text' show
```

Note that `..` is an alias for `>>=`. The [fluent interface](http://en.wikipedia.org/wiki/Fluent_interface) is just a poor man's [programmable semicolon](http://en.wikipedia.org/wiki/Monad_(functional_programming))!

The PureScript D3 bindings statically enforce several properties of D3's selection semantics; for instance, if you were to remove the `.. append "div"` above you would get a type error, because the code following it would be attempting to set things on the unrealized nodes of an [enter selection](https://github.com/mbostock/d3/wiki/Selections#enter). Similarly, if you removed the `.. bind array` line you would get a type error because you can only obtain an enter selection from an update selection (the selection produced by calling `data` in JavaScript or `bind` in PureScript). In JavaScript you would have to wait until runtime to see these kinds of errors.

Selections also carry information about the type of data bound to them (if any). Until data is bound to a selection it is only possible to set constant attributes on it; afterwards you can use well-typed functions of the data.

You can find more examples [here](https://github.com/pelotom/purescript-d3-examples/tree/master/src).

### Development

You will need the following pre-requisites installed:

*  [PureScript](http://www.purescript.org/)
*  [nodejs](http://nodejs.org/)
*  [bower](http://bower.io/) (e.g., `npm install -g bower`)
*  [gulp.js](http://gulpjs.com/) (e.g., `npm install -g gulp`)

Once you have these installed you can run the following in a cloned repo:

```
npm install    # install dependencies from package.json
bower update   # install dependencies from bower.json
gulp           # compile the code
```

# Module Documentation

## Module Graphics.D3.SVG.Axis

#### `Axis`

``` purescript
data Axis :: *
```


#### `axis`

``` purescript
axis :: D3Eff Axis
```


#### `scale`

``` purescript
scale :: forall s d. (Scale s) => s d Number -> Axis -> D3Eff Axis
```


#### `orient`

``` purescript
orient :: String -> Axis -> D3Eff Axis
```


#### `ticks`

``` purescript
ticks :: Number -> Axis -> D3Eff Axis
```


#### `tickFormat`

``` purescript
tickFormat :: String -> Axis -> D3Eff Axis
```


#### `renderAxis`

``` purescript
renderAxis :: forall s d. (Existing s) => Axis -> s d -> D3Eff (Selection d)
```



## Module Graphics.D3.Base

#### `D3`

``` purescript
data D3 :: !
```


#### `D3Eff`

``` purescript
type D3Eff a = forall e. Eff (d3 :: D3 | e) a
```



## Module Graphics.D3.Interpolate

#### `Interpolator`

``` purescript
data Interpolator :: * -> *
```


#### `makeInterpolator`

``` purescript
makeInterpolator :: forall a. (a -> a -> Number -> a) -> Interpolator a
```



## Module Graphics.D3.Request

#### `RequestError`

``` purescript
type RequestError = { statusText :: String, status :: Number }
```


#### `csv`

``` purescript
csv :: forall e a. String -> (Either RequestError [Foreign] -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
```


#### `tsv`

``` purescript
tsv :: forall e a. String -> (Either RequestError [Foreign] -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
```


#### `json`

``` purescript
json :: forall e a. String -> (Either RequestError Foreign -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
```



## Module Graphics.D3.Scale

#### `Scale`

``` purescript
class Scale s where
  domain :: forall d r. [d] -> s d r -> D3Eff (s d r)
  range :: forall d r. [r] -> s d r -> D3Eff (s d r)
  copy :: forall d r. s d r -> D3Eff (s d r)
  toFunction :: forall d r. s d r -> D3Eff (d -> r)
```

#### `Quantitative`

``` purescript
class Quantitative s where
  invert :: s Number Number -> D3Eff (Number -> Number)
  rangeRound :: [Number] -> s Number Number -> D3Eff (s Number Number)
  interpolate :: forall r. Interpolator r -> s Number r -> D3Eff (s Number r)
  clamp :: forall r. Boolean -> s Number r -> D3Eff (s Number r)
  nice :: forall r. Maybe Number -> s Number r -> D3Eff (s Number r)
  getTicks :: forall r. Maybe Number -> s Number r -> D3Eff [Number]
  getTickFormat :: forall r. Number -> Maybe String -> s Number r -> D3Eff (Number -> String)
```

#### `LinearScale`

``` purescript
data LinearScale :: * -> * -> *
```

#### `PowerScale`

``` purescript
data PowerScale :: * -> * -> *
```


#### `LogScale`

``` purescript
data LogScale :: * -> * -> *
```


#### `OrdinalScale`

``` purescript
data OrdinalScale :: * -> * -> *
```


#### `linearScale`

``` purescript
linearScale :: forall r. D3Eff (LinearScale Number r)
```

#### `powerScale`

``` purescript
powerScale :: forall r. D3Eff (PowerScale Number r)
```


#### `sqrtScale`

``` purescript
sqrtScale :: forall r. D3Eff (PowerScale Number r)
```


#### `logScale`

``` purescript
logScale :: forall r. D3Eff (LogScale Number r)
```


#### `ordinalScale`

``` purescript
ordinalScale :: forall d r. D3Eff (OrdinalScale d r)
```


#### `exponent`

``` purescript
exponent :: forall r. Number -> PowerScale Number r -> D3Eff (PowerScale Number r)
```

#### `base`

``` purescript
base :: forall r. Number -> LogScale Number r -> D3Eff (LogScale Number r)
```

#### `rangePoints`

``` purescript
rangePoints :: forall d. Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
```

#### `rangeBands`

``` purescript
rangeBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
```


#### `rangeRoundBands`

``` purescript
rangeRoundBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)
```


#### `rangeBand`

``` purescript
rangeBand :: forall d r. OrdinalScale d Number -> D3Eff Number
```


#### `rangeExtent`

``` purescript
rangeExtent :: forall d r. OrdinalScale d Number -> D3Eff (Tuple Number Number)
```


#### `scaleLinear`

``` purescript
instance scaleLinear :: Scale LinearScale
```

#### `quantitativeLinear`

``` purescript
instance quantitativeLinear :: Quantitative LinearScale
```


#### `scalePower`

``` purescript
instance scalePower :: Scale PowerScale
```


#### `quantitativePower`

``` purescript
instance quantitativePower :: Quantitative PowerScale
```


#### `scaleLog`

``` purescript
instance scaleLog :: Scale LogScale
```


#### `quantitativeLog`

``` purescript
instance quantitativeLog :: Quantitative LogScale
```


#### `scaleOrdinal`

``` purescript
instance scaleOrdinal :: Scale OrdinalScale
```



## Module Graphics.D3.Selection

#### `Selection`

``` purescript
data Selection :: * -> *
```

#### `Update`

``` purescript
data Update :: * -> *
```


#### `Enter`

``` purescript
data Enter :: * -> *
```


#### `Transition`

``` purescript
data Transition :: * -> *
```


#### `Exit`

``` purescript
type Exit d = Selection d
```

#### `Void`

``` purescript
data Void
```

#### `AttrValue`

``` purescript
class AttrValue a where
```

#### `attrValNumber`

``` purescript
instance attrValNumber :: AttrValue Number
```


#### `attrValString`

``` purescript
instance attrValString :: AttrValue String
```


#### `rootSelect`

``` purescript
rootSelect :: String -> D3Eff (Selection Void)
```


#### `rootSelectAll`

``` purescript
rootSelectAll :: String -> D3Eff (Selection Void)
```


#### `select`

``` purescript
select :: forall d. String -> Selection d -> D3Eff (Selection d)
```


#### `selectAll`

``` purescript
selectAll :: forall d. String -> Selection d -> D3Eff (Selection Void)
```


#### `bind`

``` purescript
bind :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (Update newData)
```


#### `enter`

``` purescript
enter :: forall d. Update d -> D3Eff (Enter d)
```


#### `exit`

``` purescript
exit :: forall d. Update d -> D3Eff (Exit d)
```


#### `transition`

``` purescript
transition :: forall s d. (Existing s) => s d -> D3Eff (Transition d)
```


#### `delay`

``` purescript
delay :: forall d. Number -> Transition d -> D3Eff (Transition d)
```

#### `delay'`

``` purescript
delay' :: forall d. (d -> Number) -> Transition d -> D3Eff (Transition d)
```


#### `delay''`

``` purescript
delay'' :: forall d. (d -> Number -> Number) -> Transition d -> D3Eff (Transition d)
```


#### `duration`

``` purescript
duration :: forall d. Number -> Transition d -> D3Eff (Transition d)
```


#### `duration'`

``` purescript
duration' :: forall d. (d -> Number) -> Transition d -> D3Eff (Transition d)
```


#### `duration''`

``` purescript
duration'' :: forall d. (d -> Number -> Number) -> Transition d -> D3Eff (Transition d)
```


#### `Appendable`

``` purescript
class Appendable s where
  append :: forall d. String -> s d -> D3Eff (Selection d)
```

#### `appendableSelection`

``` purescript
instance appendableSelection :: Appendable Selection
```


#### `appendableUpdate`

``` purescript
instance appendableUpdate :: Appendable Update
```


#### `appendableEnter`

``` purescript
instance appendableEnter :: Appendable Enter
```


#### `Existing`

``` purescript
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
```

#### `existingSelection`

``` purescript
instance existingSelection :: Existing Selection
```


#### `existingUpdate`

``` purescript
instance existingUpdate :: Existing Update
```


#### `existingTransition`

``` purescript
instance existingTransition :: Existing Transition
```


#### `Clickable`

``` purescript
class Clickable c where
  onClick :: forall eff r. (Foreign -> Eff eff r) -> c -> D3Eff c
  onDoubleClick :: forall eff r. (Foreign -> Eff eff r) -> c -> D3Eff c
```


#### `clickableSelection`

``` purescript
instance clickableSelection :: Clickable (Selection a)
```



## Module Graphics.D3.Time

#### `TimeScale`

``` purescript
data TimeScale :: * -> * -> *
```


#### `timeScale`

``` purescript
timeScale :: forall r. D3Eff (TimeScale JSDate r)
```


#### `scaleTime`

``` purescript
instance scaleTime :: Scale TimeScale
```



## Module Graphics.D3.Unsafe


## Module Graphics.D3.Util

#### `Magnitude`

``` purescript
class Magnitude n where
```


#### `numberMagnitude`

``` purescript
instance numberMagnitude :: Magnitude Number
```


#### `dateMagnitude`

``` purescript
instance dateMagnitude :: Magnitude JSDate
```


#### `min'`

``` purescript
min' :: forall d m. (Magnitude m) => (d -> m) -> [d] -> m
```


#### `max'`

``` purescript
max' :: forall d m. (Magnitude m) => (d -> m) -> [d] -> m
```


#### `min`

``` purescript
min :: forall m. (Magnitude m) => [m] -> m
```


#### `max`

``` purescript
max :: forall d m. (Magnitude m) => [m] -> m
```


#### `extent`

``` purescript
extent :: forall m. (Magnitude m) => [m] -> [m]
```


## Module Graphics.D3.Layout.Base

#### `GraphLayout`

``` purescript
class GraphLayout l where
  nodes :: forall a. [a] -> l -> D3Eff l
  links :: forall a. [a] -> l -> D3Eff l
  size :: forall d. { height :: Number, width :: Number | d } -> l -> D3Eff l
```



## Module Graphics.D3.Layout.Force

#### `ForceLayout`

``` purescript
data ForceLayout :: *
```


#### `forceLayout`

``` purescript
forceLayout :: D3Eff ForceLayout
```


#### `forceGraphLayout`

``` purescript
instance forceGraphLayout :: GraphLayout ForceLayout
```


#### `linkDistance`

``` purescript
linkDistance :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `linkStrength`

``` purescript
linkStrength :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `friction`

``` purescript
friction :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `charge`

``` purescript
charge :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `chargeDistance`

``` purescript
chargeDistance :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `theta`

``` purescript
theta :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `gravity`

``` purescript
gravity :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `start`

``` purescript
start :: ForceLayout -> D3Eff ForceLayout
```


#### `alpha`

``` purescript
alpha :: Number -> ForceLayout -> D3Eff ForceLayout
```


#### `resume`

``` purescript
resume :: ForceLayout -> D3Eff ForceLayout
```


#### `stop`

``` purescript
stop :: ForceLayout -> D3Eff ForceLayout
```


#### `tick`

``` purescript
tick :: ForceLayout -> D3Eff ForceLayout
```


#### `onTick`

``` purescript
onTick :: forall e r. (Foreign -> Eff e r) -> ForceLayout -> D3Eff ForceLayout
```


#### `onDragStart`

``` purescript
onDragStart :: forall e r. (Foreign -> Eff e r) -> ForceLayout -> D3Eff ForceLayout
```


#### `drag`

``` purescript
drag :: ForceLayout -> D3Eff ForceLayout
```


#### `createDrag`

``` purescript
createDrag :: forall s. ForceLayout -> Selection s -> D3Eff (Selection s)
```




