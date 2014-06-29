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


## Module Graphics.D3.Selection

### Values

    append :: forall e a. String -> D3Eff e a -> D3Eff e a

    attr :: forall e a. String -> a -> D3Eff e Unit

    bind :: forall d e a. [d] -> D3Eff e a -> D3Eff e a

    enter :: forall e a. D3Eff e a -> D3Eff e a

    exit :: forall e a. D3Eff e a -> D3Eff e a

    remove :: forall e. D3Eff e Unit

    select :: forall e a. String -> D3Eff e a -> D3Eff e a

    selectAll :: forall e a. String -> D3Eff e a -> D3Eff e a

    transition :: forall e a. D3Eff e a -> D3Eff e a


## Module Graphics.D3.Raw.Selection

### Types

    data Selection :: *


### Values

    d3Append :: forall e. String -> Selection -> D3Eff e Selection

    d3Enter :: forall e. Selection -> D3Eff e Selection

    d3Exit :: forall e. Selection -> D3Eff e Selection

    d3Remove :: forall e. Selection -> D3Eff e Unit

    d3Select :: forall e. String -> D3Eff e Selection

    d3SelectAll :: forall e. String -> D3Eff e Selection

    d3SelectAllFrom :: forall e. String -> Selection -> D3Eff e Selection

    d3SelectFrom :: forall e. String -> Selection -> D3Eff e Selection

    d3SetAttr :: forall a e. String -> a -> Selection -> D3Eff e Unit

    d3SetData :: forall d e. [d] -> Selection -> D3Eff e Selection

    d3Transition :: forall e. Selection -> D3Eff e Selection



