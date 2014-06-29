module Graphics.D3.Examples.Rectangles where

import Graphics.D3.Selection

drawRects array =
  selectAll "svg" $ bind [1] do
    enter $ append "svg" $ append "rect" do
      attr "width" 1000
      attr "height" 500
      attr "fill" "orange"
    selectAll ".others" $ bind array do
      enter $ append "rect" do
        attr "class" "others"
        attr "fill" \d -> if d > 4 then "green" else "red"
        attr "stroke" "black"
      attr "x" \d -> d * 10
      attr "y" \d -> d * 20
      attr "width" \d -> d * 100
      attr "height" \d -> d * 50
      exit remove

main = drawRects [1,2,3,4,5,6,7]