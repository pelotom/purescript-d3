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

### Types

    data Axis :: *


### Values

    axis :: D3Eff Axis

    orient :: String -> Axis -> D3Eff Axis

    renderAxis :: forall s d. (Existing s) => Axis -> s d -> D3Eff (Selection d)

    scale :: forall s d. (Scale s) => s d Number -> Axis -> D3Eff Axis

    tickFormat :: String -> Axis -> D3Eff Axis

    ticks :: Number -> Axis -> D3Eff Axis


## Module Graphics.D3.Base

### Types

    data D3 :: !

    type D3Eff a = forall e. Eff (d3 :: D3 | e) a


## Module Graphics.D3.Interpolate

### Types

    data Interpolator :: * -> *


### Values

    makeInterpolator :: forall a. (a -> a -> Number -> a) -> Interpolator a


## Module Graphics.D3.Request

### Types

    type RequestError = { statusText :: String, status :: Number }


### Values

    json :: forall e a. String -> (Either RequestError Foreign -> Eff (d3 :: D3 | e) a) -> D3Eff Unit

    tsv :: forall e a. String -> (Either RequestError [Foreign] -> Eff (d3 :: D3 | e) a) -> D3Eff Unit


## Module Graphics.D3.Scale

### Types

    data LinearScale :: * -> * -> *

    data LogScale :: * -> * -> *

    data OrdinalScale :: * -> * -> *

    data PowerScale :: * -> * -> *


### Type Classes

    class Quantitative s where
      invert :: s Number Number -> D3Eff (Number -> Number)
      rangeRound :: [Number] -> s Number Number -> D3Eff (s Number Number)
      interpolate :: forall r. Interpolator r -> s Number r -> D3Eff (s Number r)
      clamp :: forall r. Boolean -> s Number r -> D3Eff (s Number r)
      nice :: forall r. Maybe Number -> s Number r -> D3Eff (s Number r)
      getTicks :: forall r. Maybe Number -> s Number r -> D3Eff [Number]
      getTickFormat :: forall r. Number -> Maybe String -> s Number r -> D3Eff (Number -> String)

    class Scale s where
      domain :: forall d r. [d] -> s d r -> D3Eff (s d r)
      range :: forall d r. [r] -> s d r -> D3Eff (s d r)
      copy :: forall d r. s d r -> D3Eff (s d r)
      toFunction :: forall d r. s d r -> D3Eff (d -> r)


### Type Class Instances

    instance quantitativeLinear :: Quantitative LinearScale

    instance quantitativeLog :: Quantitative LogScale

    instance quantitativePower :: Quantitative PowerScale

    instance scaleLinear :: Scale LinearScale

    instance scaleLog :: Scale LogScale

    instance scaleOrdinal :: Scale OrdinalScale

    instance scalePower :: Scale PowerScale


### Values

    base :: forall r. Number -> LogScale Number r -> D3Eff (LogScale Number r)

    exponent :: forall r. Number -> PowerScale Number r -> D3Eff (PowerScale Number r)

    linearScale :: forall r. D3Eff (LinearScale Number r)

    logScale :: forall r. D3Eff (LogScale Number r)

    ordinalScale :: forall d r. D3Eff (OrdinalScale d r)

    powerScale :: forall r. D3Eff (PowerScale Number r)

    rangeBand :: forall d r. OrdinalScale d Number -> D3Eff Number

    rangeBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)

    rangeExtent :: forall d r. OrdinalScale d Number -> D3Eff (Tuple Number Number)

    rangePoints :: forall d. Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)

    rangeRoundBands :: forall d. Number -> Number -> Number -> Number -> OrdinalScale d Number -> D3Eff (OrdinalScale d Number)

    sqrtScale :: forall r. D3Eff (PowerScale Number r)


## Module Graphics.D3.Selection

### Types

    data Enter :: * -> *

    type Exit d = Selection d

    data Selection :: * -> *

    data Transition :: * -> *

    data Update :: * -> *

    data Void


### Type Classes

    class Appendable s where
      append :: forall d. String -> s d -> D3Eff (Selection d)

    class AttrValue a where

    class Clickable c where
      onClick :: forall eff r. (Foreign -> Eff eff r) -> c -> D3Eff c
      onDoubleClick :: forall eff r. (Foreign -> Eff eff r) -> c -> D3Eff c

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


### Type Class Instances

    instance appendableEnter :: Appendable Enter

    instance appendableSelection :: Appendable Selection

    instance appendableUpdate :: Appendable Update

    instance attrValNumber :: AttrValue Number

    instance attrValString :: AttrValue String

    instance clickableSelection :: Clickable (Selection a)

    instance existingSelection :: Existing Selection

    instance existingTransition :: Existing Transition

    instance existingUpdate :: Existing Update


### Values

    bind :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (Update newData)

    delay :: forall d. Number -> Transition d -> D3Eff (Transition d)

    delay' :: forall d. (d -> Number) -> Transition d -> D3Eff (Transition d)

    delay'' :: forall d. (d -> Number -> Number) -> Transition d -> D3Eff (Transition d)

    duration :: forall d. Number -> Transition d -> D3Eff (Transition d)

    duration' :: forall d. (d -> Number) -> Transition d -> D3Eff (Transition d)

    duration'' :: forall d. (d -> Number -> Number) -> Transition d -> D3Eff (Transition d)

    enter :: forall d. Update d -> D3Eff (Enter d)

    exit :: forall d. Update d -> D3Eff (Exit d)

    rootSelect :: String -> D3Eff (Selection Void)

    rootSelectAll :: String -> D3Eff (Selection Void)

    select :: forall d. String -> Selection d -> D3Eff (Selection d)

    selectAll :: forall d. String -> Selection d -> D3Eff (Selection Void)

    transition :: forall s d. (Existing s) => s d -> D3Eff (Transition d)


## Module Graphics.D3.Util

### Values

    max :: forall d. (d -> Number) -> [d] -> Number

    min :: forall d. (d -> Number) -> [d] -> Number


## Module Graphics.D3.Layout.Base

### Type Classes

    class GraphLayout l where
      nodes :: forall a. [a] -> l -> D3Eff l
      links :: forall a. [a] -> l -> D3Eff l
      size :: forall d. { height :: Number, width :: Number | d } -> l -> D3Eff l


## Module Graphics.D3.Layout.Force

### Types

    data ForceLayout :: *


### Type Class Instances

    instance forceGraphLayout :: GraphLayout ForceLayout


### Values

    alpha :: Number -> ForceLayout -> D3Eff ForceLayout

    charge :: Number -> ForceLayout -> D3Eff ForceLayout

    chargeDistance :: Number -> ForceLayout -> D3Eff ForceLayout

    createDrag :: forall s. ForceLayout -> Selection s -> D3Eff (Selection s)

    drag :: ForceLayout -> D3Eff ForceLayout

    forceLayout :: D3Eff ForceLayout

    friction :: Number -> ForceLayout -> D3Eff ForceLayout

    gravity :: Number -> ForceLayout -> D3Eff ForceLayout

    linkDistance :: Number -> ForceLayout -> D3Eff ForceLayout

    linkStrength :: Number -> ForceLayout -> D3Eff ForceLayout

    onDragStart :: forall e r. (Foreign -> Eff e r) -> ForceLayout -> D3Eff ForceLayout

    onTick :: forall e r. (Foreign -> Eff e r) -> ForceLayout -> D3Eff ForceLayout

    resume :: ForceLayout -> D3Eff ForceLayout

    start :: ForceLayout -> D3Eff ForceLayout

    stop :: ForceLayout -> D3Eff ForceLayout

    theta :: Number -> ForceLayout -> D3Eff ForceLayout

    tick :: ForceLayout -> D3Eff ForceLayout



