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

And here is the PureScript code which accomplishes the same:

```haskell
do
  let table = [4, 8, 15, 16, 23, 42]

  x <- linearScale
    .. domain [0, max table]
    .. range [0, 420]
    .. freeze

  rootSelect ".chart"
    .. selectAll "div"
      .. bind table
    .. enter .. append "div"
      .. style "width" (\d -> show (x d) ++ "px")
      .. text (\d -> d)
```

Note that `..` is just an alias for `>>=`. The [fluent interface](http://en.wikipedia.org/wiki/Fluent_interface) is just a poor man's [programmable semicolon](http://en.wikipedia.org/wiki/Monad_(functional_programming))!

This and other examples can be found [here](https://github.com/pelotom/purescript-d3-examples/tree/master/src).

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

## Module Graphics.D3.Base

### Types

    type Change a = a -> Effect a

    data DOM :: !

    type Effect a = forall e. Eff (dom :: DOM | e) a


### Values

    void :: forall f a. (Functor f) => f a -> f Unit


## Module Graphics.D3.Scale

### Types

    data LinearScale :: *


### Type Classes


### Type Class Instances

    instance scaleLinear :: Scale LinearScale


### Values

    domain :: forall s a. (Scale s) => [a] -> Change s

    freeze :: forall s. (Scale s) => s -> Effect (Number -> Number)

    linearScale :: Effect LinearScale

    range :: forall s a. (Scale s) => [a] -> Change s


## Module Graphics.D3.Selection

### Types

    data Selection :: *


### Values

    append :: String -> Change Selection

    attr :: forall a. String -> a -> Change Selection

    bind :: forall d. [d] -> Change Selection

    enter :: Change Selection

    exit :: Change Selection

    remove :: Selection -> Effect Unit

    rootSelect :: String -> Effect Selection

    rootSelectAll :: String -> Effect Selection

    select :: String -> Change Selection

    selectAll :: String -> Change Selection

    style :: forall a. String -> a -> Change Selection

    text :: forall a. a -> Change Selection

    transition :: Change Selection


## Module Graphics.D3.Util

### Values

    max :: [Number] -> Number

    min :: [Number] -> Number



