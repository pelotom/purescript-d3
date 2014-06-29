# purescript-d3 : PureScript bindings for [D3](http://d3js.org/)

The main idea of this library, beyond providing raw bindings, is to mimic the "fluent interface" of D3 by threading the current selection through the `Eff` monad. This makes it very straightforward to port existing D3 visualizations (and knowledge of how to write D3 code) to PureScript.

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
