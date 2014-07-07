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
table = [4, 8, 15, 16, 23, 42]

main = do

  x <- linearScale
    .. domain [0, max table]
    .. range [0, 420]
    .. freeze

  rootSelect ".chart"
    .. selectAll "div"
      .. bind table
    .. enter .. append "div"
      .. style' "width" (\d -> show (x d) ++ "px")
      .. text' show
```

Note that `..` is an alias for `>>=`. The [fluent interface](http://en.wikipedia.org/wiki/Fluent_interface) is just a poor man's [programmable semicolon](http://en.wikipedia.org/wiki/Monad_(functional_programming))!

The PureScript D3 bindings statically enforce several properties of D3's selection semantics; for instance, if you were to remove the `.. append "div"` above you would get a type error, because the following code would be attempting to set things on the unrealized nodes of an enter selection. In JavaScript you would have to wait until runtime to see that error.

PureScript selections also carry information about the type of data bound to them (if any). Until data is bound to a selection it is only possible to set constant attributes on it; afterwards you can use well-typed functions of the data.

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

    scale :: forall s. (Scale s) => s -> Axis -> D3Eff Axis

    tickFormat :: String -> Axis -> D3Eff Axis

    ticks :: Number -> Axis -> D3Eff Axis


## Module Graphics.D3.Base

### Types

    data D3 :: !

    type D3Eff a = forall e. Eff (d3 :: D3 | e) a


## Module Graphics.D3.Request

### Types

    type RequestError  = { statusText :: String, status :: Number }


### Values

    tsv :: forall e a. String -> (Either RequestError [Foreign] -> Eff e a) -> Eff (d3 :: D3 | e) Unit


## Module Graphics.D3.Scale

### Types

    data LinearScale :: *

    data OrdinalScale :: *


### Type Classes

    class Scale s where


### Type Class Instances

    instance scaleLinear :: Scale LinearScale

    instance scaleOrdinal :: Scale OrdinalScale


### Values

    domain :: forall s a. (Scale s) => [a] -> s -> D3Eff s

    freeze :: forall s a. (Scale s) => s -> D3Eff (a -> Number)

    linearScale :: D3Eff LinearScale

    ordinalScale :: D3Eff OrdinalScale

    range :: forall s a. (Scale s) => [a] -> s -> D3Eff s

    rangeBand :: OrdinalScale -> D3Eff Number

    rangeRoundBands :: Number -> Number -> Number -> Number -> OrdinalScale -> D3Eff OrdinalScale


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

    instance attrValNumber :: AttrValue Prim.Number

    instance attrValString :: AttrValue Prim.String

    instance existingSelection :: Existing Selection

    instance existingTransition :: Existing Transition

    instance existingUpdate :: Existing Update


### Values

    bind :: forall oldData newData. [newData] -> Selection oldData -> D3Eff (Update newData)

    enter :: forall d. Update d -> D3Eff (Enter d)

    exit :: forall d. Update d -> D3Eff (Exit d)

    rootSelect :: String -> D3Eff (Selection Void)

    rootSelectAll :: String -> D3Eff (Selection Void)

    select :: forall d. String -> Selection d -> D3Eff (Selection d)

    selectAll :: forall d. String -> Selection d -> D3Eff (Selection Void)

    transition :: forall d. Selection d -> D3Eff (Transition d)


## Module Graphics.D3.Util

### Values

    max :: [Number] -> Number

    maxBy :: forall d. (d -> Number) -> [d] -> Number

    min :: [Number] -> Number



