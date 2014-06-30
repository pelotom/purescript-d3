# purescript-d3

The main idea of this library, beyond providing raw bindings for [D3](http://d3js.org/), is to mimic its [fluent interface](http://en.wikipedia.org/wiki/Fluent_interface) by threading the current selection through the `Eff` monad. This makes it very straightforward to port existing D3 visualizations (and knowledge of how to write D3 code) to PureScript.

### Example

Here's a (fairly silly) example that draws a bunch of rectangles and circles, animating their entry and exit from the scene.

```purescript
module Graphics.D3.Examples.Rectangles where

import Graphics.D3

drawRects array =
  selectAll "svg" $ bind [1] do
    enter $ append "svg" $ append "rect" do
      attr "width" 500
      attr "height" 500
      attr "fill" "gray"
    selectAll ".others" $ bind array do
      enter $ append "g" do
        attr "opacity" 0
        append "rect" do
          attr "class" "others"
          attr "fill" \d -> if d > 4 then "blue" else "red"
          attr "stroke" "black"
          attr "x" \d -> d * 13
          attr "y" \d -> d * 20
          attr "opacity" 1
          attr "width" \d -> d * 60
          attr "height" \d -> d * 50
        append "circle" do
          attr "cx" \d -> d * 13
          attr "cy" \d -> d * 20
          attr "r" 10
          attr "fill" "green"
        transition $ attr "opacity" 1
      exit $ transition do
        attr "opacity" 0
        remove

main = drawRects [1,2,3,4,5,6,7]
```

More examples can be found [here](https://github.com/pelotom/purescript-d3-examples/tree/master/src).

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

    type D3Eff e a = Eff (dom :: DOM | e) a

    data DOM :: !


### Values

    void :: forall f a. (Functor f) => f a -> f Unit


## Module Graphics.D3.Scale

### Types

    data LinearScale :: *


### Type Classes


### Type Class Instances

    instance scaleLinear :: Scale LinearScale


### Values

    domain :: forall s a e. (Scale s) => [a] -> s -> D3Eff e LinearScale

    freeze :: forall s e. (Scale s) => s -> D3Eff e (Number -> Number)

    linearScale :: forall e. D3Eff e LinearScale

    range :: forall s a e. (Scale s) => [a] -> s -> D3Eff e LinearScale


## Module Graphics.D3.Selection

### Types

    data Selection :: *


### Values

    append :: forall e. String -> Selection -> D3Eff e Selection

    attr :: forall a e. String -> a -> Selection -> D3Eff e Selection

    bind :: forall d e. [d] -> Selection -> D3Eff e Selection

    enter :: forall e. Selection -> D3Eff e Selection

    exit :: forall e. Selection -> D3Eff e Selection

    remove :: forall e. Selection -> D3Eff e Unit

    rootSelect :: forall e. String -> D3Eff e Selection

    rootSelectAll :: forall e. String -> D3Eff e Selection

    select :: forall e. String -> Selection -> D3Eff e Selection

    selectAll :: forall e. String -> Selection -> D3Eff e Selection

    style :: forall a e. String -> a -> Selection -> D3Eff e Selection

    text :: forall a e. a -> Selection -> D3Eff e Selection

    transition :: forall e. Selection -> D3Eff e Selection


## Module Graphics.D3.Util

### Values

    max :: [Number] -> Number

    min :: [Number] -> Number



