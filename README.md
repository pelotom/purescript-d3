# purescript-d3 : PureScript bindings for D3

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


## Module Graphics.D3

### Values

    append :: forall e a. String -> D3Eff e a -> D3Eff e a

    attr :: forall e a. String -> a -> D3Eff e Unit

    bind :: forall d e a. [d] -> D3Eff e a -> D3Eff e a

    enter :: forall e a. D3Eff e a -> D3Eff e a

    select :: forall e a. String -> D3Eff e a -> D3Eff e a

    selectAll :: forall e a. String -> D3Eff e a -> D3Eff e a


## Module Graphics.D3.Raw

### Types

    data Selection :: *


### Values

    d3AppendTo :: forall e. String -> Selection -> D3Eff e Selection

    d3Enter :: forall e. Selection -> D3Eff e Selection

    d3Select :: forall e. String -> D3Eff e Selection

    d3SelectAll :: forall e. String -> D3Eff e Selection

    d3SelectAllFrom :: forall e. String -> Selection -> D3Eff e Selection

    d3SelectFrom :: forall e. String -> Selection -> D3Eff e Selection

    d3SetAttr :: forall a e. String -> a -> Selection -> D3Eff e Unit

    d3SetData :: forall d e. [d] -> Selection -> D3Eff e Selection



