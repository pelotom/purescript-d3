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

## Module Prelude

#### `Unit`

``` purescript
newtype Unit
```

The `Unit` type has a single inhabitant, called `unit`. It represents
values with no computational content.

`Unit` is often used, wrapped in a monadic type constructor, as the
return type of a computation where only
the _effects_ are important.

##### Instances
``` purescript
instance semigroupUnit :: Semigroup Unit
instance semiringUnit :: Semiring Unit
instance ringUnit :: Ring Unit
instance moduloSemiringUnit :: ModuloSemiring Unit
instance divisionRingUnit :: DivisionRing Unit
instance numUnit :: Num Unit
instance eqUnit :: Eq Unit
instance ordUnit :: Ord Unit
instance boundedUnit :: Bounded Unit
instance boundedOrdUnit :: BoundedOrd Unit
instance booleanAlgebraUnit :: BooleanAlgebra Unit
instance showUnit :: Show Unit
```

#### `unit`

``` purescript
unit :: Unit
```

`unit` is the sole inhabitant of the `Unit` type.

#### `($)`

``` purescript
($) :: forall a b. (a -> b) -> a -> b
```

_right-associative / precedence 0_

Applies a function to its argument.

```purescript
length $ groupBy productCategory $ filter isInStock $ products
```

is equivalent to:

```purescript
length (groupBy productCategory (filter isInStock products))
```

`($)` is different from [`(#)`](#-2) because it is right-infix instead of
left: `a $ b $ c $ d x = a $ (b $ (c $ (d $ x))) = a (b (c (d x)))`

#### `(#)`

``` purescript
(#) :: forall a b. a -> (a -> b) -> b
```

_left-associative / precedence 1_

Applies an argument to a function.

```purescript
products # filter isInStock # groupBy productCategory # length
```

is equivalent to:

```purescript
length (groupBy productCategory (filter isInStock products))
```

`(#)` is different from [`($)`](#-1) because it is left-infix instead of
right: `x # a # b # c # d = (((x # a) # b) # c) # d = d (c (b (a x)))`

#### `flip`

``` purescript
flip :: forall a b c. (a -> b -> c) -> b -> a -> c
```

Flips the order of the arguments to a function of two arguments.

```purescript
flip const 1 2 = const 2 1 = 2
```

#### `const`

``` purescript
const :: forall a b. a -> b -> a
```

Returns its first argument and ignores its second.

```purescript
const 1 "hello" = 1
```

#### `asTypeOf`

``` purescript
asTypeOf :: forall a. a -> a -> a
```

This function returns its first argument, and can be used to assert type
equalities. This can be useful when types are otherwise ambiguous.

```purescript
main = print $ [] `asTypeOf` [0]
```

If instead, we had written `main = print []`, the type of the argument
`[]` would have been ambiguous, resulting in a compile-time error.

#### `otherwise`

``` purescript
otherwise :: Boolean
```

An alias for `true`, which can be useful in guard clauses:

```purescript
max x y | x >= y    = x
        | otherwise = y
```

#### `Semigroupoid`

``` purescript
class Semigroupoid a where
  compose :: forall b c d. a c d -> a b c -> a b d
```

A `Semigroupoid` is similar to a [`Category`](#category) but does not
require an identity element `id`, just composable morphisms.

`Semigroupoid`s must satisfy the following law:

- Associativity: `p <<< (q <<< r) = (p <<< q) <<< r`

One example of a `Semigroupoid` is the function type constructor `(->)`,
with `(<<<)` defined as function composition.

##### Instances
``` purescript
instance semigroupoidFn :: Semigroupoid Function
```

#### `(<<<)`

``` purescript
(<<<) :: forall a b c d. (Semigroupoid a) => a c d -> a b c -> a b d
```

_right-associative / precedence 9_

`(<<<)` is an alias for `compose`.

#### `(>>>)`

``` purescript
(>>>) :: forall a b c d. (Semigroupoid a) => a b c -> a c d -> a b d
```

_right-associative / precedence 9_

Forwards composition, or `(<<<)` with its arguments reversed.

#### `Category`

``` purescript
class (Semigroupoid a) <= Category a where
  id :: forall t. a t t
```

`Category`s consist of objects and composable morphisms between them, and
as such are [`Semigroupoids`](#semigroupoid), but unlike `semigroupoids`
must have an identity element.

Instances must satisfy the following law in addition to the
`Semigroupoid` law:

- Identity: `id <<< p = p <<< id = p`

##### Instances
``` purescript
instance categoryFn :: Category Function
```

#### `Functor`

``` purescript
class Functor f where
  map :: forall a b. (a -> b) -> f a -> f b
```

A `Functor` is a type constructor which supports a mapping operation
`(<$>)`.

`(<$>)` can be used to turn functions `a -> b` into functions
`f a -> f b` whose argument and return types use the type constructor `f`
to represent some computational context.

Instances must satisfy the following laws:

- Identity: `(<$>) id = id`
- Composition: `(<$>) (f <<< g) = (f <$>) <<< (g <$>)`

##### Instances
``` purescript
instance functorFn :: Functor (Function r)
instance functorArray :: Functor Array
```

#### `(<$>)`

``` purescript
(<$>) :: forall f a b. (Functor f) => (a -> b) -> f a -> f b
```

_left-associative / precedence 4_

`(<$>)` is an alias for `map`

#### `(<#>)`

``` purescript
(<#>) :: forall f a b. (Functor f) => f a -> (a -> b) -> f b
```

_left-associative / precedence 1_

`(<#>)` is `(<$>)` with its arguments reversed. For example:

```purescript
[1, 2, 3] <#> \n -> n * n
```

#### `void`

``` purescript
void :: forall f a. (Functor f) => f a -> f Unit
```

The `void` function is used to ignore the type wrapped by a
[`Functor`](#functor), replacing it with `Unit` and keeping only the type
information provided by the type constructor itself.

`void` is often useful when using `do` notation to change the return type
of a monadic computation:

```purescript
main = forE 1 10 \n -> void do
  print n
  print (n * n)
```

#### `Apply`

``` purescript
class (Functor f) <= Apply f where
  apply :: forall a b. f (a -> b) -> f a -> f b
```

The `Apply` class provides the `(<*>)` which is used to apply a function
to an argument under a type constructor.

`Apply` can be used to lift functions of two or more arguments to work on
values wrapped with the type constructor `f`. It might also be understood
in terms of the `lift2` function:

```purescript
lift2 :: forall f a b c. (Apply f) => (a -> b -> c) -> f a -> f b -> f c
lift2 f a b = f <$> a <*> b
```

`(<*>)` is recovered from `lift2` as `lift2 ($)`. That is, `(<*>)` lifts
the function application operator `($)` to arguments wrapped with the
type constructor `f`.

Instances must satisfy the following law in addition to the `Functor`
laws:

- Associative composition: `(<<<) <$> f <*> g <*> h = f <*> (g <*> h)`

Formally, `Apply` represents a strong lax semi-monoidal endofunctor.

##### Instances
``` purescript
instance applyFn :: Apply (Function r)
instance applyArray :: Apply Array
```

#### `(<*>)`

``` purescript
(<*>) :: forall f a b. (Apply f) => f (a -> b) -> f a -> f b
```

_left-associative / precedence 4_

`(<*>)` is an alias for `apply`.

#### `Applicative`

``` purescript
class (Apply f) <= Applicative f where
  pure :: forall a. a -> f a
```

The `Applicative` type class extends the [`Apply`](#apply) type class
with a `pure` function, which can be used to create values of type `f a`
from values of type `a`.

Where [`Apply`](#apply) provides the ability to lift functions of two or
more arguments to functions whose arguments are wrapped using `f`, and
[`Functor`](#functor) provides the ability to lift functions of one
argument, `pure` can be seen as the function which lifts functions of
_zero_ arguments. That is, `Applicative` functors support a lifting
operation for any number of function arguments.

Instances must satisfy the following laws in addition to the `Apply`
laws:

- Identity: `(pure id) <*> v = v`
- Composition: `(pure <<<) <*> f <*> g <*> h = f <*> (g <*> h)`
- Homomorphism: `(pure f) <*> (pure x) = pure (f x)`
- Interchange: `u <*> (pure y) = (pure ($ y)) <*> u`

##### Instances
``` purescript
instance applicativeFn :: Applicative (Function r)
instance applicativeArray :: Applicative Array
```

#### `return`

``` purescript
return :: forall m a. (Applicative m) => a -> m a
```

`return` is an alias for `pure`.

#### `liftA1`

``` purescript
liftA1 :: forall f a b. (Applicative f) => (a -> b) -> f a -> f b
```

`liftA1` provides a default implementation of `(<$>)` for any
[`Applicative`](#applicative) functor, without using `(<$>)` as provided
by the [`Functor`](#functor)-[`Applicative`](#applicative) superclass
relationship.

`liftA1` can therefore be used to write [`Functor`](#functor) instances
as follows:

```purescript
instance functorF :: Functor F where
  map = liftA1
```

#### `Bind`

``` purescript
class (Apply m) <= Bind m where
  bind :: forall a b. m a -> (a -> m b) -> m b
```

The `Bind` type class extends the [`Apply`](#apply) type class with a
"bind" operation `(>>=)` which composes computations in sequence, using
the return value of one computation to determine the next computation.

The `>>=` operator can also be expressed using `do` notation, as follows:

```purescript
x >>= f = do y <- x
             f y
```

where the function argument of `f` is given the name `y`.

Instances must satisfy the following law in addition to the `Apply`
laws:

- Associativity: `(x >>= f) >>= g = x >>= (\k => f k >>= g)`

Associativity tells us that we can regroup operations which use `do`
notation so that we can unambiguously write, for example:

```purescript
do x <- m1
   y <- m2 x
   m3 x y
```

##### Instances
``` purescript
instance bindFn :: Bind (Function r)
instance bindArray :: Bind Array
```

#### `(>>=)`

``` purescript
(>>=) :: forall m a b. (Bind m) => m a -> (a -> m b) -> m b
```

_left-associative / precedence 1_

`(>>=)` is an alias for `bind`.

#### `Monad`

``` purescript
class (Applicative m, Bind m) <= Monad m
```

The `Monad` type class combines the operations of the `Bind` and
`Applicative` type classes. Therefore, `Monad` instances represent type
constructors which support sequential composition, and also lifting of
functions of arbitrary arity.

Instances must satisfy the following laws in addition to the
`Applicative` and `Bind` laws:

- Left Identity: `pure x >>= f = f x`
- Right Identity: `x >>= pure = x`

##### Instances
``` purescript
instance monadFn :: Monad (Function r)
instance monadArray :: Monad Array
```

#### `liftM1`

``` purescript
liftM1 :: forall m a b. (Monad m) => (a -> b) -> m a -> m b
```

`liftM1` provides a default implementation of `(<$>)` for any
[`Monad`](#monad), without using `(<$>)` as provided by the
[`Functor`](#functor)-[`Monad`](#monad) superclass relationship.

`liftM1` can therefore be used to write [`Functor`](#functor) instances
as follows:

```purescript
instance functorF :: Functor F where
  map = liftM1
```

#### `ap`

``` purescript
ap :: forall m a b. (Monad m) => m (a -> b) -> m a -> m b
```

`ap` provides a default implementation of `(<*>)` for any
[`Monad`](#monad), without using `(<*>)` as provided by the
[`Apply`](#apply)-[`Monad`](#monad) superclass relationship.

`ap` can therefore be used to write [`Apply`](#apply) instances as
follows:

```purescript
instance applyF :: Apply F where
  apply = ap
```

#### `Semigroup`

``` purescript
class Semigroup a where
  append :: a -> a -> a
```

The `Semigroup` type class identifies an associative operation on a type.

Instances are required to satisfy the following law:

- Associativity: `(x <> y) <> z = x <> (y <> z)`

One example of a `Semigroup` is `String`, with `(<>)` defined as string
concatenation.

##### Instances
``` purescript
instance semigroupString :: Semigroup String
instance semigroupUnit :: Semigroup Unit
instance semigroupFn :: (Semigroup s') => Semigroup (s -> s')
instance semigroupOrdering :: Semigroup Ordering
instance semigroupArray :: Semigroup (Array a)
```

#### `(<>)`

``` purescript
(<>) :: forall s. (Semigroup s) => s -> s -> s
```

_right-associative / precedence 5_

`(<>)` is an alias for `append`.

#### `(++)`

``` purescript
(++) :: forall s. (Semigroup s) => s -> s -> s
```

_right-associative / precedence 5_

`(++)` is an alternative alias for `append`.

#### `Semiring`

``` purescript
class Semiring a where
  add :: a -> a -> a
  zero :: a
  mul :: a -> a -> a
  one :: a
```

The `Semiring` class is for types that support an addition and
multiplication operation.

Instances must satisfy the following laws:

- Commutative monoid under addition:
  - Associativity: `(a + b) + c = a + (b + c)`
  - Identity: `zero + a = a + zero = a`
  - Commutative: `a + b = b + a`
- Monoid under multiplication:
  - Associativity: `(a * b) * c = a * (b * c)`
  - Identity: `one * a = a * one = a`
- Multiplication distributes over addition:
  - Left distributivity: `a * (b + c) = (a * b) + (a * c)`
  - Right distributivity: `(a + b) * c = (a * c) + (b * c)`
- Annihiliation: `zero * a = a * zero = zero`

##### Instances
``` purescript
instance semiringInt :: Semiring Int
instance semiringNumber :: Semiring Number
instance semiringUnit :: Semiring Unit
```

#### `(+)`

``` purescript
(+) :: forall a. (Semiring a) => a -> a -> a
```

_left-associative / precedence 6_

`(+)` is an alias for `add`.

#### `(*)`

``` purescript
(*) :: forall a. (Semiring a) => a -> a -> a
```

_left-associative / precedence 7_

`(*)` is an alias for `mul`.

#### `Ring`

``` purescript
class (Semiring a) <= Ring a where
  sub :: a -> a -> a
```

The `Ring` class is for types that support addition, multiplication,
and subtraction operations.

Instances must satisfy the following law in addition to the `Semiring`
laws:

- Additive inverse: `a - a = (zero - a) + a = zero`

##### Instances
``` purescript
instance ringInt :: Ring Int
instance ringNumber :: Ring Number
instance ringUnit :: Ring Unit
```

#### `(-)`

``` purescript
(-) :: forall a. (Ring a) => a -> a -> a
```

_left-associative / precedence 6_

`(-)` is an alias for `sub`.

#### `negate`

``` purescript
negate :: forall a. (Ring a) => a -> a
```

`negate x` can be used as a shorthand for `zero - x`.

#### `ModuloSemiring`

``` purescript
class (Semiring a) <= ModuloSemiring a where
  div :: a -> a -> a
  mod :: a -> a -> a
```

The `ModuloSemiring` class is for types that support addition,
multiplication, division, and modulo (division remainder) operations.

Instances must satisfy the following law in addition to the `Semiring`
laws:

- Remainder: ``a / b * b + (a `mod` b) = a``

##### Instances
``` purescript
instance moduloSemiringInt :: ModuloSemiring Int
instance moduloSemiringNumber :: ModuloSemiring Number
instance moduloSemiringUnit :: ModuloSemiring Unit
```

#### `(/)`

``` purescript
(/) :: forall a. (ModuloSemiring a) => a -> a -> a
```

_left-associative / precedence 7_

`(/)` is an alias for `div`.

#### `DivisionRing`

``` purescript
class (Ring a, ModuloSemiring a) <= DivisionRing a
```

A `Ring` where every nonzero element has a multiplicative inverse.

Instances must satisfy the following law in addition to the `Ring` and
`ModuloSemiring` laws:

- Multiplicative inverse: `(one / x) * x = one`

As a consequence of this ```a `mod` b = zero``` as no divide operation
will have a remainder.

##### Instances
``` purescript
instance divisionRingNumber :: DivisionRing Number
instance divisionRingUnit :: DivisionRing Unit
```

#### `Num`

``` purescript
class (DivisionRing a) <= Num a
```

The `Num` class is for types that are commutative fields.

Instances must satisfy the following law in addition to the
`DivisionRing` laws:

- Commutative multiplication: `a * b = b * a`

##### Instances
``` purescript
instance numNumber :: Num Number
instance numUnit :: Num Unit
```

#### `Eq`

``` purescript
class Eq a where
  eq :: a -> a -> Boolean
```

The `Eq` type class represents types which support decidable equality.

`Eq` instances should satisfy the following laws:

- Reflexivity: `x == x = true`
- Symmetry: `x == y = y == x`
- Transitivity: if `x == y` and `y == z` then `x == z`

##### Instances
``` purescript
instance eqBoolean :: Eq Boolean
instance eqInt :: Eq Int
instance eqNumber :: Eq Number
instance eqChar :: Eq Char
instance eqString :: Eq String
instance eqUnit :: Eq Unit
instance eqArray :: (Eq a) => Eq (Array a)
instance eqOrdering :: Eq Ordering
```

#### `(==)`

``` purescript
(==) :: forall a. (Eq a) => a -> a -> Boolean
```

_non-associative / precedence 4_

`(==)` is an alias for `eq`. Tests whether one value is equal to another.

#### `(/=)`

``` purescript
(/=) :: forall a. (Eq a) => a -> a -> Boolean
```

_non-associative / precedence 4_

`(/=)` tests whether one value is _not equal_ to another. Shorthand for
`not (x == y)`.

#### `Ordering`

``` purescript
data Ordering
  = LT
  | GT
  | EQ
```

The `Ordering` data type represents the three possible outcomes of
comparing two values:

`LT` - The first value is _less than_ the second.
`GT` - The first value is _greater than_ the second.
`EQ` - The first value is _equal to_ the second.

##### Instances
``` purescript
instance semigroupOrdering :: Semigroup Ordering
instance eqOrdering :: Eq Ordering
instance ordOrdering :: Ord Ordering
instance boundedOrdering :: Bounded Ordering
instance boundedOrdOrdering :: BoundedOrd Ordering
instance showOrdering :: Show Ordering
```

#### `Ord`

``` purescript
class (Eq a) <= Ord a where
  compare :: a -> a -> Ordering
```

The `Ord` type class represents types which support comparisons with a
_total order_.

`Ord` instances should satisfy the laws of total orderings:

- Reflexivity: `a <= a`
- Antisymmetry: if `a <= b` and `b <= a` then `a = b`
- Transitivity: if `a <= b` and `b <= c` then `a <= c`

##### Instances
``` purescript
instance ordBoolean :: Ord Boolean
instance ordInt :: Ord Int
instance ordNumber :: Ord Number
instance ordString :: Ord String
instance ordChar :: Ord Char
instance ordUnit :: Ord Unit
instance ordArray :: (Ord a) => Ord (Array a)
instance ordOrdering :: Ord Ordering
```

#### `(<)`

``` purescript
(<) :: forall a. (Ord a) => a -> a -> Boolean
```

_left-associative / precedence 4_

Test whether one value is _strictly less than_ another.

#### `(>)`

``` purescript
(>) :: forall a. (Ord a) => a -> a -> Boolean
```

_left-associative / precedence 4_

Test whether one value is _strictly greater than_ another.

#### `(<=)`

``` purescript
(<=) :: forall a. (Ord a) => a -> a -> Boolean
```

_left-associative / precedence 4_

Test whether one value is _non-strictly less than_ another.

#### `(>=)`

``` purescript
(>=) :: forall a. (Ord a) => a -> a -> Boolean
```

_left-associative / precedence 4_

Test whether one value is _non-strictly greater than_ another.

#### `unsafeCompare`

``` purescript
unsafeCompare :: forall a. a -> a -> Ordering
```

#### `Bounded`

``` purescript
class Bounded a where
  top :: a
  bottom :: a
```

The `Bounded` type class represents types that are finite.

Although there are no "internal" laws for `Bounded`, every value of `a`
should be considered less than or equal to `top` by some means, and greater
than or equal to `bottom`.

The lack of explicit `Ord` constraint allows flexibility in the use of
`Bounded` so it can apply to total and partially ordered sets, boolean
algebras, etc.

##### Instances
``` purescript
instance boundedBoolean :: Bounded Boolean
instance boundedUnit :: Bounded Unit
instance boundedOrdering :: Bounded Ordering
instance boundedInt :: Bounded Int
instance boundedChar :: Bounded Char
instance boundedFn :: (Bounded b) => Bounded (a -> b)
```

#### `BoundedOrd`

``` purescript
class (Bounded a, Ord a) <= BoundedOrd a
```

The `BoundedOrd` type class represents totally ordered finite data types.

Instances should satisfy the following law in addition to the `Ord` laws:

- Ordering: `bottom <= a <= top`

##### Instances
``` purescript
instance boundedOrdBoolean :: BoundedOrd Boolean
instance boundedOrdUnit :: BoundedOrd Unit
instance boundedOrdOrdering :: BoundedOrd Ordering
instance boundedOrdInt :: BoundedOrd Int
instance boundedOrdChar :: BoundedOrd Char
```

#### `BooleanAlgebra`

``` purescript
class (Bounded a) <= BooleanAlgebra a where
  conj :: a -> a -> a
  disj :: a -> a -> a
  not :: a -> a
```

The `BooleanAlgebra` type class represents types that behave like boolean
values.

Instances should satisfy the following laws in addition to the `Bounded`
laws:

- Associativity:
  - `a || (b || c) = (a || b) || c`
  - `a && (b && c) = (a && b) && c`
- Commutativity:
  - `a || b = b || a`
  - `a && b = b && a`
- Distributivity:
  - `a && (b || c) = (a && b) || (a && c)`
  - `a || (b && c) = (a || b) && (a || c)`
- Identity:
  - `a || bottom = a`
  - `a && top = a`
- Idempotent:
  - `a || a = a`
  - `a && a = a`
- Absorption:
  - `a || (a && b) = a`
  - `a && (a || b) = a`
- Annhiliation:
  - `a || top = top`
- Complementation:
  - `a && not a = bottom`
  - `a || not a = top`

##### Instances
``` purescript
instance booleanAlgebraBoolean :: BooleanAlgebra Boolean
instance booleanAlgebraUnit :: BooleanAlgebra Unit
instance booleanAlgebraFn :: (BooleanAlgebra b) => BooleanAlgebra (a -> b)
```

#### `(&&)`

``` purescript
(&&) :: forall a. (BooleanAlgebra a) => a -> a -> a
```

_right-associative / precedence 3_

`(&&)` is an alias for `conj`.

#### `(||)`

``` purescript
(||) :: forall a. (BooleanAlgebra a) => a -> a -> a
```

_right-associative / precedence 2_

`(||)` is an alias for `disj`.

#### `Show`

``` purescript
class Show a where
  show :: a -> String
```

The `Show` type class represents those types which can be converted into
a human-readable `String` representation.

While not required, it is recommended that for any expression `x`, the
string `show x` be executable PureScript code which evaluates to the same
value as the expression `x`.

##### Instances
``` purescript
instance showBoolean :: Show Boolean
instance showInt :: Show Int
instance showNumber :: Show Number
instance showChar :: Show Char
instance showString :: Show String
instance showUnit :: Show Unit
instance showArray :: (Show a) => Show (Array a)
instance showOrdering :: Show Ordering
```


## Module Math

Wraps the math functions and constants from Javascript's built-in `Math` object.
See [Math Reference at MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math).

#### `Radians`

``` purescript
type Radians = Number
```

An alias to make types in this module more explicit.

#### `abs`

``` purescript
abs :: Number -> Number
```

Returns the absolute value of the argument.

#### `acos`

``` purescript
acos :: Number -> Radians
```

Returns the inverse cosine of the argument.

#### `asin`

``` purescript
asin :: Number -> Radians
```

Returns the inverse sine of the argument.

#### `atan`

``` purescript
atan :: Number -> Radians
```

Returns the inverse tangent of the argument.

#### `atan2`

``` purescript
atan2 :: Number -> Number -> Radians
```

Four-quadrant tangent inverse. Given the arguments `y` and `x`, returns
the inverse tangent of `y / x`, where the signs of both arguments are used
to determine the sign of the result.
If the first argument is negative, the result will be negative.
The result is the angle between the positive x axis and  a point `(x, y)`.

#### `ceil`

``` purescript
ceil :: Number -> Number
```

Returns the smallest integer not smaller than the argument.

#### `cos`

``` purescript
cos :: Radians -> Number
```

Returns the cosine of the argument.

#### `exp`

``` purescript
exp :: Number -> Number
```

Returns `e` exponentiated to the power of the argument.

#### `floor`

``` purescript
floor :: Number -> Number
```

Returns the largest integer not larger than the argument.

#### `log`

``` purescript
log :: Number -> Number
```

Returns the natural logarithm of a number.

#### `max`

``` purescript
max :: Number -> Number -> Number
```

Returns the largest of two numbers.

#### `min`

``` purescript
min :: Number -> Number -> Number
```

Returns the smallest of two numbers.

#### `pow`

``` purescript
pow :: Number -> Number -> Number
```

Return  the first argument exponentiated to the power of the second argument.

#### `round`

``` purescript
round :: Number -> Number
```

Returns the integer closest to the argument.

#### `sin`

``` purescript
sin :: Radians -> Number
```

Returns the sine of the argument.

#### `sqrt`

``` purescript
sqrt :: Number -> Number
```

Returns the square root of the argument.

#### `tan`

``` purescript
tan :: Radians -> Number
```

Returns the tangent of the argument.

#### `(%)`

``` purescript
(%) :: Number -> Number -> Number
```

_left-associative / precedence 7_

Computes the remainder after division, wrapping Javascript's `%` operator.

#### `e`

``` purescript
e :: Number
```

The base of natural logarithms, *e*, around 2.71828.

#### `ln2`

``` purescript
ln2 :: Number
```

The natural logarithm of 2, around 0.6931.

#### `ln10`

``` purescript
ln10 :: Number
```

The natural logarithm of 10, around 2.3025.

#### `log2e`

``` purescript
log2e :: Number
```

The base 2 logarithm of `e`, around 1.4426.

#### `log10e`

``` purescript
log10e :: Number
```

Base 10 logarithm of `e`, around 0.43429.

#### `pi`

``` purescript
pi :: Number
```

The ratio of the circumference of a circle to its diameter, around 3.14159.

#### `sqrt1_2`

``` purescript
sqrt1_2 :: Number
```

The Square root of one half, around 0.707107.

#### `sqrt2`

``` purescript
sqrt2 :: Number
```

The square root of two, around 1.41421.


## Module Global.Unsafe

#### `unsafeStringify`

``` purescript
unsafeStringify :: forall a. a -> String
```

Uses the global JSON object to turn anything into a string. Careful! Trying
to serialize functions returns undefined


## Module Global

This module defines types for some global Javascript functions
and values.

#### `nan`

``` purescript
nan :: Number
```

Not a number (NaN)

#### `isNaN`

``` purescript
isNaN :: Number -> Boolean
```

Test whether a number is NaN

#### `infinity`

``` purescript
infinity :: Number
```

Positive infinity

#### `isFinite`

``` purescript
isFinite :: Number -> Boolean
```

Test whether a number is finite

#### `readInt`

``` purescript
readInt :: Int -> String -> Number
```

Parse an integer from a `String` in the specified base

#### `readFloat`

``` purescript
readFloat :: String -> Number
```

Parse a floating point value from a `String`


## Module Data.Time

#### `HourOfDay`

``` purescript
newtype HourOfDay
  = HourOfDay Int
```

An hour component from a time value. Should fall between 0 and 23
inclusive.

##### Instances
``` purescript
instance eqHourOfDay :: Eq HourOfDay
instance ordHourOfDay :: Ord HourOfDay
```

#### `Hours`

``` purescript
newtype Hours
  = Hours Number
```

A quantity of hours (not necessarily a value between 0 and 23).

##### Instances
``` purescript
instance eqHours :: Eq Hours
instance ordHours :: Ord Hours
instance semiringHours :: Semiring Hours
instance ringHours :: Ring Hours
instance moduloSemiringHours :: ModuloSemiring Hours
instance divisionRingHours :: DivisionRing Hours
instance numHours :: Num Hours
instance showHours :: Show Hours
instance timeValueHours :: TimeValue Hours
```

#### `MinuteOfHour`

``` purescript
newtype MinuteOfHour
  = MinuteOfHour Int
```

A minute component from a time value. Should fall between 0 and 59
inclusive.

##### Instances
``` purescript
instance eqMinuteOfHour :: Eq MinuteOfHour
instance ordMinuteOfHour :: Ord MinuteOfHour
```

#### `Minutes`

``` purescript
newtype Minutes
  = Minutes Number
```

A quantity of minutes (not necessarily a value between 0 and 60).

##### Instances
``` purescript
instance eqMinutes :: Eq Minutes
instance ordMinutes :: Ord Minutes
instance semiringMinutes :: Semiring Minutes
instance ringMinutes :: Ring Minutes
instance moduloSemiringMinutes :: ModuloSemiring Minutes
instance divisionRingMinutes :: DivisionRing Minutes
instance numMinutes :: Num Minutes
instance showMinutes :: Show Minutes
instance timeValueMinutes :: TimeValue Minutes
```

#### `SecondOfMinute`

``` purescript
newtype SecondOfMinute
  = SecondOfMinute Int
```

A second component from a time value. Should fall between 0 and 59
inclusive.

##### Instances
``` purescript
instance eqSecondOfMinute :: Eq SecondOfMinute
instance ordSecondOfMinute :: Ord SecondOfMinute
```

#### `Seconds`

``` purescript
newtype Seconds
  = Seconds Number
```

A quantity of seconds (not necessarily a value between 0 and 60).

##### Instances
``` purescript
instance eqSeconds :: Eq Seconds
instance ordSeconds :: Ord Seconds
instance semiringSeconds :: Semiring Seconds
instance ringSeconds :: Ring Seconds
instance moduloSemiringSeconds :: ModuloSemiring Seconds
instance divisionRingSeconds :: DivisionRing Seconds
instance numSeconds :: Num Seconds
instance showSeconds :: Show Seconds
instance timeValueSeconds :: TimeValue Seconds
```

#### `MillisecondOfSecond`

``` purescript
newtype MillisecondOfSecond
  = MillisecondOfSecond Int
```

A millisecond component from a time value. Should fall between 0 and 999
inclusive.

##### Instances
``` purescript
instance eqMillisecondOfSecond :: Eq MillisecondOfSecond
instance ordMillisecondOfSecond :: Ord MillisecondOfSecond
```

#### `Milliseconds`

``` purescript
newtype Milliseconds
  = Milliseconds Number
```

A quantity of milliseconds (not necessarily a value between 0 and 1000).

##### Instances
``` purescript
instance eqMilliseconds :: Eq Milliseconds
instance ordMilliseconds :: Ord Milliseconds
instance semiringMilliseconds :: Semiring Milliseconds
instance ringMilliseconds :: Ring Milliseconds
instance moduloSemiringMilliseconds :: ModuloSemiring Milliseconds
instance divisionRingMilliseconds :: DivisionRing Milliseconds
instance numMilliseconds :: Num Milliseconds
instance showMilliseconds :: Show Milliseconds
instance timeValueMilliseconds :: TimeValue Milliseconds
```

#### `TimeValue`

``` purescript
class TimeValue a where
  toHours :: a -> Hours
  toMinutes :: a -> Minutes
  toSeconds :: a -> Seconds
  toMilliseconds :: a -> Milliseconds
  fromHours :: Hours -> a
  fromMinutes :: Minutes -> a
  fromSeconds :: Seconds -> a
  fromMilliseconds :: Milliseconds -> a
```

##### Instances
``` purescript
instance timeValueHours :: TimeValue Hours
instance timeValueMinutes :: TimeValue Minutes
instance timeValueSeconds :: TimeValue Seconds
instance timeValueMilliseconds :: TimeValue Milliseconds
```


## Module Data.Monoid

#### `Monoid`

``` purescript
class (Semigroup m) <= Monoid m where
  mempty :: m
```

A `Monoid` is a `Semigroup` with a value `mempty`, which is both a
left and right unit for the associative operation `<>`:

```text
forall x. mempty <> x = x <> mempty = x
```

`Monoid`s are commonly used as the result of fold operations, where
`<>` is used to combine individual results, and `mempty` gives the result
of folding an empty collection of elements.

##### Instances
``` purescript
instance monoidUnit :: Monoid Unit
instance monoidFn :: (Monoid b) => Monoid (a -> b)
instance monoidString :: Monoid String
instance monoidArray :: Monoid (Array a)
```


## Module Data.Int.Bits

This module defines bitwise operations for the `Int` type.

#### `(.&.)`

``` purescript
(.&.) :: Int -> Int -> Int
```

_left-associative / precedence 10_

Bitwise AND.

#### `(.|.)`

``` purescript
(.|.) :: Int -> Int -> Int
```

_left-associative / precedence 10_

Bitwise OR.

#### `(.^.)`

``` purescript
(.^.) :: Int -> Int -> Int
```

_left-associative / precedence 10_

Bitwise XOR.

#### `shl`

``` purescript
shl :: Int -> Int -> Int
```

Bitwise shift left.

#### `shr`

``` purescript
shr :: Int -> Int -> Int
```

Bitwise shift right.

#### `zshr`

``` purescript
zshr :: Int -> Int -> Int
```

Bitwise zero-fill shift right.

#### `complement`

``` purescript
complement :: Int -> Int
```

Bitwise NOT.


## Module Data.Functor.Invariant

#### `Invariant`

``` purescript
class Invariant f where
  imap :: forall a b. (a -> b) -> (b -> a) -> f a -> f b
```

A type of functor that can be used to adapt the type of a wrapped function
where the parameterised type occurs in both the positive and negative
position, for example, `F (a -> a)`.

An `Invariant` instance should satisfy the following laws:

- Identity: `imap id id = id`
- Composition: `imap g1 g2 <<< imap f1 f2 = imap (g1 <<< f1) (f2 <<< g2)`


##### Instances
``` purescript
instance invariantFn :: Invariant (Function a)
instance invariantArray :: Invariant Array
```

#### `imapF`

``` purescript
imapF :: forall f a b. (Functor f) => (a -> b) -> (b -> a) -> f a -> f b
```

As all `Functor`s are also trivially `Invariant`, this function can be
used as the `imap` implementation for all `Invariant` instances for
`Functors`.


## Module Data.Monoid.Endo

#### `Endo`

``` purescript
newtype Endo a
  = Endo (a -> a)
```

Monoid of endomorphisms under composition.

Composes of functions of type `a -> a`:
``` purescript
Endo f <> Endo g == Endo (f <<< g)
mempty :: Endo _ == Endo id
```

##### Instances
``` purescript
instance invariantEndo :: Invariant Endo
instance semigroupEndo :: Semigroup (Endo a)
instance monoidEndo :: Monoid (Endo a)
```

#### `runEndo`

``` purescript
runEndo :: forall a. Endo a -> a -> a
```


## Module Data.Functor

This module defines helper functions for working with `Functor` instances.

#### `(<$)`

``` purescript
(<$) :: forall f a b. (Functor f) => a -> f b -> f a
```

_left-associative / precedence 4_

Ignore the return value of a computation, using the specified return value instead.

#### `($>)`

``` purescript
($>) :: forall f a b. (Functor f) => f a -> b -> f b
```

_left-associative / precedence 4_

A version of `(<$)` with its arguments flipped.


## Module Data.Function

#### `on`

``` purescript
on :: forall a b c. (b -> b -> c) -> (a -> b) -> a -> a -> c
```

The `on` function is used to change the domain of a binary operator.

For example, we can create a function which compares two records based on the values of their `x` properties:

```purescript
compareX :: forall r. { x :: Number | r } -> { x :: Number | r } -> Ordering
compareX = compare `on` _.x
```

#### `Fn0`

``` purescript
data Fn0 :: * -> *
```

A function of zero arguments

#### `Fn1`

``` purescript
data Fn1 :: * -> * -> *
```

A function of one argument

#### `Fn2`

``` purescript
data Fn2 :: * -> * -> * -> *
```

A function of two arguments

#### `Fn3`

``` purescript
data Fn3 :: * -> * -> * -> * -> *
```

A function of three arguments

#### `Fn4`

``` purescript
data Fn4 :: * -> * -> * -> * -> * -> *
```

A function of four arguments

#### `Fn5`

``` purescript
data Fn5 :: * -> * -> * -> * -> * -> * -> *
```

A function of five arguments

#### `Fn6`

``` purescript
data Fn6 :: * -> * -> * -> * -> * -> * -> * -> *
```

A function of six arguments

#### `Fn7`

``` purescript
data Fn7 :: * -> * -> * -> * -> * -> * -> * -> * -> *
```

A function of seven arguments

#### `Fn8`

``` purescript
data Fn8 :: * -> * -> * -> * -> * -> * -> * -> * -> * -> *
```

A function of eight arguments

#### `Fn9`

``` purescript
data Fn9 :: * -> * -> * -> * -> * -> * -> * -> * -> * -> * -> *
```

A function of nine arguments

#### `Fn10`

``` purescript
data Fn10 :: * -> * -> * -> * -> * -> * -> * -> * -> * -> * -> * -> *
```

A function of ten arguments

#### `mkFn0`

``` purescript
mkFn0 :: forall a. (Unit -> a) -> Fn0 a
```

Create a function of no arguments

#### `mkFn1`

``` purescript
mkFn1 :: forall a b. (a -> b) -> Fn1 a b
```

Create a function of one argument

#### `mkFn2`

``` purescript
mkFn2 :: forall a b c. (a -> b -> c) -> Fn2 a b c
```

Create a function of two arguments from a curried function

#### `mkFn3`

``` purescript
mkFn3 :: forall a b c d. (a -> b -> c -> d) -> Fn3 a b c d
```

Create a function of three arguments from a curried function

#### `mkFn4`

``` purescript
mkFn4 :: forall a b c d e. (a -> b -> c -> d -> e) -> Fn4 a b c d e
```

Create a function of four arguments from a curried function

#### `mkFn5`

``` purescript
mkFn5 :: forall a b c d e f. (a -> b -> c -> d -> e -> f) -> Fn5 a b c d e f
```

Create a function of five arguments from a curried function

#### `mkFn6`

``` purescript
mkFn6 :: forall a b c d e f g. (a -> b -> c -> d -> e -> f -> g) -> Fn6 a b c d e f g
```

Create a function of six arguments from a curried function

#### `mkFn7`

``` purescript
mkFn7 :: forall a b c d e f g h. (a -> b -> c -> d -> e -> f -> g -> h) -> Fn7 a b c d e f g h
```

Create a function of seven arguments from a curried function

#### `mkFn8`

``` purescript
mkFn8 :: forall a b c d e f g h i. (a -> b -> c -> d -> e -> f -> g -> h -> i) -> Fn8 a b c d e f g h i
```

Create a function of eight arguments from a curried function

#### `mkFn9`

``` purescript
mkFn9 :: forall a b c d e f g h i j. (a -> b -> c -> d -> e -> f -> g -> h -> i -> j) -> Fn9 a b c d e f g h i j
```

Create a function of nine arguments from a curried function

#### `mkFn10`

``` purescript
mkFn10 :: forall a b c d e f g h i j k. (a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> k) -> Fn10 a b c d e f g h i j k
```

Create a function of ten arguments from a curried function

#### `runFn0`

``` purescript
runFn0 :: forall a. Fn0 a -> a
```

Apply a function of no arguments

#### `runFn1`

``` purescript
runFn1 :: forall a b. Fn1 a b -> a -> b
```

Apply a function of one argument

#### `runFn2`

``` purescript
runFn2 :: forall a b c. Fn2 a b c -> a -> b -> c
```

Apply a function of two arguments

#### `runFn3`

``` purescript
runFn3 :: forall a b c d. Fn3 a b c d -> a -> b -> c -> d
```

Apply a function of three arguments

#### `runFn4`

``` purescript
runFn4 :: forall a b c d e. Fn4 a b c d e -> a -> b -> c -> d -> e
```

Apply a function of four arguments

#### `runFn5`

``` purescript
runFn5 :: forall a b c d e f. Fn5 a b c d e f -> a -> b -> c -> d -> e -> f
```

Apply a function of five arguments

#### `runFn6`

``` purescript
runFn6 :: forall a b c d e f g. Fn6 a b c d e f g -> a -> b -> c -> d -> e -> f -> g
```

Apply a function of six arguments

#### `runFn7`

``` purescript
runFn7 :: forall a b c d e f g h. Fn7 a b c d e f g h -> a -> b -> c -> d -> e -> f -> g -> h
```

Apply a function of seven arguments

#### `runFn8`

``` purescript
runFn8 :: forall a b c d e f g h i. Fn8 a b c d e f g h i -> a -> b -> c -> d -> e -> f -> g -> h -> i
```

Apply a function of eight arguments

#### `runFn9`

``` purescript
runFn9 :: forall a b c d e f g h i j. Fn9 a b c d e f g h i j -> a -> b -> c -> d -> e -> f -> g -> h -> i -> j
```

Apply a function of nine arguments

#### `runFn10`

``` purescript
runFn10 :: forall a b c d e f g h i j k. Fn10 a b c d e f g h i j k -> a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> k
```

Apply a function of ten arguments


## Module Data.Foreign.EasyFFI

#### `unsafeForeignProcedure`

``` purescript
unsafeForeignProcedure :: forall a. Array String -> String -> a
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


## Module Graphics.D3.Unsafe


## Module Data.Char

A type and functions for single characters.

#### `toString`

``` purescript
toString :: Char -> String
```

Returns the string of length `1` containing only the given character.

#### `toCharCode`

``` purescript
toCharCode :: Char -> Int
```

Returns the numeric Unicode value of the character.

#### `fromCharCode`

``` purescript
fromCharCode :: Int -> Char
```

Constructs a character from the given Unicode numeric value.

#### `toLower`

``` purescript
toLower :: Char -> Char
```

Converts a character to lowercase.

#### `toUpper`

``` purescript
toUpper :: Char -> Char
```

Converts a character to uppercase.


## Module Data.String.Unsafe

Unsafe string and character functions.

#### `charCodeAt`

``` purescript
charCodeAt :: Int -> String -> Int
```

Returns the numeric Unicode value of the character at the given index.

**Unsafe:** throws runtime exception if the index is out of bounds.

#### `charAt`

``` purescript
charAt :: Int -> String -> Char
```

Returns the character at the given index.

**Unsafe:** throws runtime exception if the index is out of bounds.

#### `char`

``` purescript
char :: String -> Char
```

Converts a string of length `1` to a character.

**Unsafe:** throws runtime exception if length is not `1`.


## Module Data.Bifunctor

#### `Bifunctor`

``` purescript
class Bifunctor f where
  bimap :: forall a b c d. (a -> b) -> (c -> d) -> f a c -> f b d
```

A `Bifunctor` is a `Functor` from the pair category `(Type, Type)` to `Type`.

A type constructor with two type arguments can be made into a `Bifunctor` if
both of its type arguments are covariant.

The `bimap` function maps a pair of functions over the two type arguments
of the bifunctor.

Laws:

- Identity: `bimap id id == id`
- Composition: `bimap f1 g1 <<< bimap f2 g2 == bimap (f1 <<< f2) (g1 <<< g2)`


#### `lmap`

``` purescript
lmap :: forall f a b c. (Bifunctor f) => (a -> b) -> f a c -> f b c
```

Map a function over the first type argument of a `Bifunctor`.

#### `rmap`

``` purescript
rmap :: forall f a b c. (Bifunctor f) => (b -> c) -> f a b -> f a c
```

Map a function over the second type arguments of a `Bifunctor`.


## Module Control.Monad.Eff

#### `Eff`

``` purescript
data Eff :: # ! -> * -> *
```

The `Eff` type constructor is used to represent _native_ effects.

See [Handling Native Effects with the Eff Monad](http://www.purescript.org/learn/eff/) for more details.

The first type parameter is a row of effects which represents the contexts in which a computation can be run, and the second type parameter is the return type.

##### Instances
``` purescript
instance functorEff :: Functor (Eff e)
instance applyEff :: Apply (Eff e)
instance applicativeEff :: Applicative (Eff e)
instance bindEff :: Bind (Eff e)
instance monadEff :: Monad (Eff e)
```

#### `Pure`

``` purescript
type Pure a = Eff () a
```

The `Pure` type synonym represents _pure_ computations, i.e. ones in which all effects have been handled.

The `runPure` function can be used to run pure computations and obtain their result.

#### `runPure`

``` purescript
runPure :: forall a. Pure a -> a
```

Run a pure computation and return its result.

#### `untilE`

``` purescript
untilE :: forall e. Eff e Boolean -> Eff e Unit
```

Loop until a condition becomes `true`.

`untilE b` is an effectful computation which repeatedly runs the effectful computation `b`,
until its return value is `true`.

#### `whileE`

``` purescript
whileE :: forall e a. Eff e Boolean -> Eff e a -> Eff e Unit
```

Loop while a condition is `true`.

`whileE b m` is effectful computation which runs the effectful computation `b`. If its result is
`true`, it runs the effectful computation `m` and loops. If not, the computation ends.

#### `forE`

``` purescript
forE :: forall e. Number -> Number -> (Number -> Eff e Unit) -> Eff e Unit
```

Loop over a consecutive collection of numbers.

`forE lo hi f` runs the computation returned by the function `f` for each of the inputs
between `lo` (inclusive) and `hi` (exclusive).

#### `foreachE`

``` purescript
foreachE :: forall e a. Array a -> (a -> Eff e Unit) -> Eff e Unit
```

Loop over an array of values.

`foreach xs f` runs the computation returned by the function `f` for each of the inputs `xs`.


## Module Control.Monad.Eff.Class

#### `MonadEff`

``` purescript
class (Monad m) <= MonadEff eff m where
  liftEff :: forall a. Eff eff a -> m a
```

The `MonadEff` class captures those monads which support native effects.

Instances are provided for `Eff` itself, and the standard monad transformers.

`liftEff` can be used in any appropriate monad transformer stack to lift an action
of type `Eff eff a` into the monad.

Note that `MonadEff` is parameterized by the row of effects, so type inference can be
tricky. It is generally recommended to either work with a polymorphic row of effects,
or a concrete, closed row of effects such as `(trace :: Trace)`.

##### Instances
``` purescript
instance monadEffEff :: MonadEff eff (Eff eff)
```


## Module Control.Monad.Eff.Unsafe

#### `unsafeInterleaveEff`

``` purescript
unsafeInterleaveEff :: forall eff1 eff2 a. Eff eff1 a -> Eff eff2 a
```

Change the type of an effectful computation, allowing it to be run in another context.

Note: use of this function can result in arbitrary side-effects.


## Module Control.Monad.ST

#### `ST`

``` purescript
data ST :: * -> !
```

The `ST` effect represents _local mutation_, i.e. mutation which does not "escape" into the surrounding computation.

An `ST` computation is parameterized by a phantom type which is used to restrict the set of reference cells it is allowed to access.

The `runST` function can be used to handle the `ST` effect.

#### `STRef`

``` purescript
data STRef :: * -> * -> *
```

The type `STRef s a` represents a mutable reference holding a value of type `a`, which can be used with the `ST s` effect.

#### `newSTRef`

``` purescript
newSTRef :: forall a h r. a -> Eff (st :: ST h | r) (STRef h a)
```

Create a new mutable reference.

#### `readSTRef`

``` purescript
readSTRef :: forall a h r. STRef h a -> Eff (st :: ST h | r) a
```

Read the current value of a mutable reference.

#### `modifySTRef`

``` purescript
modifySTRef :: forall a h r. STRef h a -> (a -> a) -> Eff (st :: ST h | r) a
```

Modify the value of a mutable reference by applying a function to the current value.

#### `writeSTRef`

``` purescript
writeSTRef :: forall a h r. STRef h a -> a -> Eff (st :: ST h | r) a
```

Set the value of a mutable reference.

#### `runST`

``` purescript
runST :: forall a r. (forall h. Eff (st :: ST h | r) a) -> Eff r a
```

Run an `ST` computation.

Note: the type of `runST` uses a rank-2 type to constrain the phantom type `s`, such that the computation must not leak any mutable references
to the surrounding computation.

It may cause problems to apply this function using the `$` operator. The recommended approach is to use parentheses instead.

#### `pureST`

``` purescript
pureST :: forall a. (forall h. Eff (st :: ST h) a) -> a
```

A convenience function which combines `runST` with `runPure`, which can be used when the only required effect is `ST`.

Note: since this function has a rank-2 type, it may cause problems to apply this function using the `$` operator. The recommended approach
is to use parentheses instead.


## Module Graphics.D3.Base

#### `D3`

``` purescript
data D3 :: !
```

#### `D3Eff`

``` purescript
type D3Eff a = forall e. Eff (d3 :: D3 | e) a
```


## Module Graphics.D3.Layout.Base

#### `GraphLayout`

``` purescript
class GraphLayout l where
  nodes :: forall a. Array a -> l -> D3Eff l
  links :: forall a. Array a -> l -> D3Eff l
  size :: forall d. { width :: Number, height :: Number | d } -> l -> D3Eff l
```


## Module Control.Monad

This module defines helper functions for working with `Monad` instances.

#### `when`

``` purescript
when :: forall m. (Monad m) => Boolean -> m Unit -> m Unit
```

Perform a monadic action when a condition is true.

#### `unless`

``` purescript
unless :: forall m. (Monad m) => Boolean -> m Unit -> m Unit
```

Perform a monadic action unless a condition is true.


## Module Control.Lazy

This module defines the `Lazy` type class and associated
helper functions.

#### `Lazy`

``` purescript
class Lazy l where
  defer :: (Unit -> l) -> l
```

The `Lazy` class represents types which allow evaluation of values
to be _deferred_.

Usually, this means that a type contains a function arrow which can
be used to delay evaluation.

#### `fix`

``` purescript
fix :: forall l. (Lazy l) => (l -> l) -> l
```

`fix` defines a value as the fixed point of a function.

The `Lazy` instance allows us to generate the result lazily.


## Module Control.Extend

This module defines the `Extend` type class and associated helper functions.

#### `Extend`

``` purescript
class (Functor w) <= Extend w where
  extend :: forall b a. (w a -> b) -> w a -> w b
```

The `Extend` class defines the extension operator `(<<=)`
which extends a local context-dependent computation to
a global computation.

`Extend` is the dual of `Bind`, and `(<<=)` is the dual of
`(>>=)`.

Laws:

- Associativity: `extend f <<< extend g = extend (f <<< extend g)`

##### Instances
``` purescript
instance extendFn :: (Semigroup w) => Extend (Function w)
```

#### `(<<=)`

``` purescript
(<<=) :: forall w a b. (Extend w) => (w a -> b) -> w a -> w b
```

_right-associative / precedence 1_

An infix version of `extend`

#### `(=>>)`

``` purescript
(=>>) :: forall b a w. (Extend w) => w a -> (w a -> b) -> w b
```

_left-associative / precedence 1_

A version of `(<<=)` with its arguments flipped.

#### `(=>=)`

``` purescript
(=>=) :: forall b a w c. (Extend w) => (w a -> b) -> (w b -> c) -> w a -> c
```

_right-associative / precedence 1_

Forwards co-Kleisli composition.

#### `(=<=)`

``` purescript
(=<=) :: forall b a w c. (Extend w) => (w b -> c) -> (w a -> b) -> w a -> c
```

_right-associative / precedence 1_

Backwards co-Kleisli composition.

#### `duplicate`

``` purescript
duplicate :: forall a w. (Extend w) => w a -> w (w a)
```

Duplicate a comonadic context.

`duplicate` is dual to `Control.Bind.join`.


## Module Control.Comonad

This module defines the `Comonad` type class.

#### `Comonad`

``` purescript
class (Extend w) <= Comonad w where
  extract :: forall a. w a -> a
```

`Comonad` extends the `Extend` class with the `extract` function
which extracts a value, discarding the comonadic context.

`Comonad` is the dual of `Monad`, and `extract` is the dual of 
`pure` or `return`.

Laws:

- Left Identity: `extract <<= xs = xs`
- Right Identity: `extract (f <<= xs) = f xs`


## Module Data.Monoid.Additive

#### `Additive`

``` purescript
newtype Additive a
  = Additive a
```

Monoid and semigroup for semirings under addition.

``` purescript
Additive x <> Additive y == Additive (x + y)
mempty :: Additive _ == Additive zero
```

##### Instances
``` purescript
instance eqAdditive :: (Eq a) => Eq (Additive a)
instance ordAdditive :: (Ord a) => Ord (Additive a)
instance functorAdditive :: Functor Additive
instance applyAdditive :: Apply Additive
instance applicativeAdditive :: Applicative Additive
instance bindAdditive :: Bind Additive
instance monadAdditive :: Monad Additive
instance extendAdditive :: Extend Additive
instance comonadAdditive :: Comonad Additive
instance invariantAdditive :: Invariant Additive
instance showAdditive :: (Show a) => Show (Additive a)
instance semigroupAdditive :: (Semiring a) => Semigroup (Additive a)
instance monoidAdditive :: (Semiring a) => Monoid (Additive a)
```

#### `runAdditive`

``` purescript
runAdditive :: forall a. Additive a -> a
```


## Module Data.Monoid.Conj

#### `Conj`

``` purescript
newtype Conj a
  = Conj a
```

Monoid under conjuntion.

``` purescript
Conj x <> Conj y == Conj (x && y)
mempty :: Conj _ == Conj top
```

##### Instances
``` purescript
instance eqConj :: (Eq a) => Eq (Conj a)
instance ordConj :: (Ord a) => Ord (Conj a)
instance boundedConj :: (Bounded a) => Bounded (Conj a)
instance functorConj :: Functor Conj
instance applyConj :: Apply Conj
instance applicativeConj :: Applicative Conj
instance bindConj :: Bind Conj
instance monadConj :: Monad Conj
instance extendConj :: Extend Conj
instance comonadConj :: Comonad Conj
instance showConj :: (Show a) => Show (Conj a)
instance semigroupConj :: (BooleanAlgebra a) => Semigroup (Conj a)
instance monoidConj :: (BooleanAlgebra a) => Monoid (Conj a)
instance semiringConj :: (BooleanAlgebra a) => Semiring (Conj a)
```

#### `runConj`

``` purescript
runConj :: forall a. Conj a -> a
```


## Module Data.Monoid.Disj

#### `Disj`

``` purescript
newtype Disj a
  = Disj a
```

Monoid under disjuntion.

``` purescript
Disj x <> Disj y == Disj (x || y)
mempty :: Disj _ == Disj bottom
```

##### Instances
``` purescript
instance eqDisj :: (Eq a) => Eq (Disj a)
instance ordDisj :: (Ord a) => Ord (Disj a)
instance boundedDisj :: (Bounded a) => Bounded (Disj a)
instance functorDisj :: Functor Disj
instance applyDisj :: Apply Disj
instance applicativeDisj :: Applicative Disj
instance bindDisj :: Bind Disj
instance monadDisj :: Monad Disj
instance extendDisj :: Extend Disj
instance comonadDisj :: Comonad Disj
instance showDisj :: (Show a) => Show (Disj a)
instance semigroupDisj :: (BooleanAlgebra a) => Semigroup (Disj a)
instance monoidDisj :: (BooleanAlgebra a) => Monoid (Disj a)
instance semiringDisj :: (BooleanAlgebra a) => Semiring (Disj a)
```

#### `runDisj`

``` purescript
runDisj :: forall a. Disj a -> a
```


## Module Data.Monoid.Dual

#### `Dual`

``` purescript
newtype Dual a
  = Dual a
```

The dual of a monoid.

``` purescript
Dual x <> Dual y == Dual (y <> x)
mempty :: Dual _ == Dual mempty
```

##### Instances
``` purescript
instance eqDual :: (Eq a) => Eq (Dual a)
instance ordDual :: (Ord a) => Ord (Dual a)
instance functorDual :: Functor Dual
instance applyDual :: Apply Dual
instance applicativeDual :: Applicative Dual
instance bindDual :: Bind Dual
instance monadDual :: Monad Dual
instance extendDual :: Extend Dual
instance comonadDual :: Comonad Dual
instance invariantDual :: Invariant Dual
instance showDual :: (Show a) => Show (Dual a)
instance semigroupDual :: (Semigroup a) => Semigroup (Dual a)
instance monoidDual :: (Monoid a) => Monoid (Dual a)
```

#### `runDual`

``` purescript
runDual :: forall a. Dual a -> a
```


## Module Data.Monoid.Multiplicative

#### `Multiplicative`

``` purescript
newtype Multiplicative a
  = Multiplicative a
```

Monoid and semigroup for semirings under multiplication.

``` purescript
Multiplicative x <> Multiplicative y == Multiplicative (x * y)
mempty :: Multiplicative _ == Multiplicative one
```

##### Instances
``` purescript
instance eqMultiplicative :: (Eq a) => Eq (Multiplicative a)
instance ordMultiplicative :: (Ord a) => Ord (Multiplicative a)
instance functorMultiplicative :: Functor Multiplicative
instance applyMultiplicative :: Apply Multiplicative
instance applicativeMultiplicative :: Applicative Multiplicative
instance bindMultiplicative :: Bind Multiplicative
instance monadMultiplicative :: Monad Multiplicative
instance extendMultiplicative :: Extend Multiplicative
instance comonadMultiplicative :: Comonad Multiplicative
instance invariantMultiplicative :: Invariant Multiplicative
instance showMultiplicative :: (Show a) => Show (Multiplicative a)
instance semigroupMultiplicative :: (Semiring a) => Semigroup (Multiplicative a)
instance monoidMultiplicative :: (Semiring a) => Monoid (Multiplicative a)
```

#### `runMultiplicative`

``` purescript
runMultiplicative :: forall a. Multiplicative a -> a
```


## Module Control.Bind

This module defines helper functions for working with `Bind` instances.

#### `(=<<)`

``` purescript
(=<<) :: forall a b m. (Bind m) => (a -> m b) -> m a -> m b
```

_right-associative / precedence 1_

A version of `(>>=)` with its arguments flipped.

#### `(>=>)`

``` purescript
(>=>) :: forall a b c m. (Bind m) => (a -> m b) -> (b -> m c) -> a -> m c
```

_right-associative / precedence 1_

Forwards Kleisli composition.

For example:

```purescript
import Data.Array (head, tail)

third = tail >=> tail >=> head
```

#### `(<=<)`

``` purescript
(<=<) :: forall a b c m. (Bind m) => (b -> m c) -> (a -> m b) -> a -> m c
```

_right-associative / precedence 1_

Backwards Kleisli composition.

#### `join`

``` purescript
join :: forall a m. (Bind m) => m (m a) -> m a
```

Collapse two applications of a monadic type constructor into one.

#### `ifM`

``` purescript
ifM :: forall a m. (Bind m) => m Boolean -> m a -> m a -> m a
```

Execute a monadic action if a condition holds.

For example:

```purescript
main = ifM ((< 0.5) <$> random)
         (trace "Heads")
         (trace "Tails")
```


## Module Control.Biapply

#### `(<<$>>)`

``` purescript
(<<$>>) :: forall a b. (a -> b) -> a -> b
```

_left-associative / precedence 4_

A convenience function which can be used to apply the result of `bipure` in
the style of `Applicative`:

```purescript
bipure f g <<$>> x <<*>> y
```

#### `Biapply`

``` purescript
class (Bifunctor w) <= Biapply w where
  biapply :: forall a b c d. w (a -> b) (c -> d) -> w a c -> w b d
```

`Biapply` captures type constructors of two arguments which support lifting of
functions of one or more arguments, in the sense of `Apply`.

#### `(<<*>>)`

``` purescript
(<<*>>) :: forall w a b c d. (Biapply w) => w (a -> b) (c -> d) -> w a c -> w b d
```

_left-associative / precedence 4_

An infix version of `biapply`.

#### `(*>>)`

``` purescript
(*>>) :: forall w a b c d. (Biapply w) => w a b -> w c d -> w c d
```

_left-associative / precedence 4_

Keep the results of the second computation

#### `(<<*)`

``` purescript
(<<*) :: forall w a b c d. (Biapply w) => w a b -> w c d -> w a b
```

_left-associative / precedence 4_

Keep the results of the first computation

#### `bilift2`

``` purescript
bilift2 :: forall w a b c d e f. (Biapply w) => (a -> b -> c) -> (d -> e -> f) -> w a d -> w b e -> w c f
```

Lift a function of two arguments.

#### `bilift3`

``` purescript
bilift3 :: forall w a b c d e f g h. (Biapply w) => (a -> b -> c -> d) -> (e -> f -> g -> h) -> w a e -> w b f -> w c g -> w d h
```

Lift a function of three arguments.


## Module Control.Biapplicative

#### `Biapplicative`

``` purescript
class (Biapply w) <= Biapplicative w where
  bipure :: forall a b. a -> b -> w a b
```

`Biapplicative` captures type constructors of two arguments which support lifting of
functions of zero or more arguments, in the sense of `Applicative`.


## Module Data.Bifunctor.Clown

#### `Clown`

``` purescript
data Clown f a b
  = Clown (f a)
```

Make a `Functor` over the first argument of a `Bifunctor`

##### Instances
``` purescript
instance clownBifunctor :: (Functor f) => Bifunctor (Clown f)
instance clownFunctor :: Functor (Clown f a)
instance clownBiapply :: (Apply f) => Biapply (Clown f)
instance clownBiapplicative :: (Applicative f) => Biapplicative (Clown f)
```

#### `runClown`

``` purescript
runClown :: forall f a b. Clown f a b -> f a
```


## Module Data.Bifunctor.Flip

#### `Flip`

``` purescript
data Flip p a b
  = Flip (p b a)
```

Flips the order of the type arguments of a `Bifunctor`.

##### Instances
``` purescript
instance flipBifunctor :: (Bifunctor p) => Bifunctor (Flip p)
instance flipFunctor :: (Bifunctor p) => Functor (Flip p a)
instance flipBiapply :: (Biapply p) => Biapply (Flip p)
instance flipBiapplicative :: (Biapplicative p) => Biapplicative (Flip p)
```

#### `runFlip`

``` purescript
runFlip :: forall p a b. Flip p a b -> p b a
```

Remove the `Flip` constructor.


## Module Data.Bifunctor.Join

#### `Join`

``` purescript
data Join p a
  = Join (p a a)
```

`Join` turns a `Bifunctor` into a `Functor` by equating the
two type arguments.

##### Instances
``` purescript
instance joinFunctor :: (Bifunctor p) => Functor (Join p)
instance joinApply :: (Biapply p) => Apply (Join p)
instance joinApplicative :: (Biapplicative p) => Applicative (Join p)
```

#### `runJoin`

``` purescript
runJoin :: forall p a. Join p a -> p a a
```

Remove the `Join` constructor.


## Module Data.Bifunctor.Joker

#### `Joker`

``` purescript
data Joker g a b
  = Joker (g b)
```

Make a `Functor` over the second argument of a `Bifunctor`

##### Instances
``` purescript
instance jokerBifunctor :: (Functor g) => Bifunctor (Joker g)
instance jokerFunctor :: (Functor g) => Functor (Joker g a)
instance jokerBiapply :: (Apply g) => Biapply (Joker g)
instance jokerBiapplicative :: (Applicative g) => Biapplicative (Joker g)
```

#### `runJoker`

``` purescript
runJoker :: forall g a b. Joker g a b -> g b
```


## Module Data.Bifunctor.Product

#### `Product`

``` purescript
data Product f g a b
  = Pair (f a b) (g a b)
```

The product of two `Bifunctor`s.

##### Instances
``` purescript
instance productBifunctor :: (Bifunctor f, Bifunctor g) => Bifunctor (Product f g)
instance productBiapply :: (Biapply f, Biapply g) => Biapply (Product f g)
instance productBiapplicative :: (Biapplicative f, Biapplicative g) => Biapplicative (Product f g)
```


## Module Data.Bifunctor.Wrap

#### `Wrap`

``` purescript
data Wrap p a b
  = Wrap (p a b)
```

A `newtype` wrapper which provides a `Functor` over the second argument of
a `Bifunctor`

##### Instances
``` purescript
instance wrapBifunctor :: (Bifunctor p) => Bifunctor (Wrap p)
instance wrapFunctor :: (Bifunctor p) => Functor (Wrap p a)
instance wrapBiapply :: (Biapply p) => Biapply (Wrap p)
instance wrapBiapplicative :: (Biapplicative p) => Biapplicative (Wrap p)
```

#### `unwrap`

``` purescript
unwrap :: forall p a b. Wrap p a b -> p a b
```

Remove the `Wrap` constructor.


## Module Control.Apply

This module defines helper functions for working with `Apply` instances.

#### `(<*)`

``` purescript
(<*) :: forall a b f. (Apply f) => f a -> f b -> f a
```

_left-associative / precedence 4_

Combine two effectful actions, keeping only the result of the first.

#### `(*>)`

``` purescript
(*>) :: forall a b f. (Apply f) => f a -> f b -> f b
```

_left-associative / precedence 4_

Combine two effectful actions, keeping only the result of the second.

#### `lift2`

``` purescript
lift2 :: forall a b c f. (Apply f) => (a -> b -> c) -> f a -> f b -> f c
```

Lift a function of two arguments to a function which accepts and returns
values wrapped with the type constructor `f`.

#### `lift3`

``` purescript
lift3 :: forall a b c d f. (Apply f) => (a -> b -> c -> d) -> f a -> f b -> f c -> f d
```

Lift a function of three arguments to a function which accepts and returns
values wrapped with the type constructor `f`.

#### `lift4`

``` purescript
lift4 :: forall a b c d e f. (Apply f) => (a -> b -> c -> d -> e) -> f a -> f b -> f c -> f d -> f e
```

Lift a function of four arguments to a function which accepts and returns
values wrapped with the type constructor `f`.

#### `lift5`

``` purescript
lift5 :: forall a b c d e f g. (Apply f) => (a -> b -> c -> d -> e -> g) -> f a -> f b -> f c -> f d -> f e -> f g
```

Lift a function of five arguments to a function which accepts and returns
values wrapped with the type constructor `f`.


## Module Data.Bifoldable

#### `Bifoldable`

``` purescript
class Bifoldable p where
  bifoldr :: forall a b c. (a -> c -> c) -> (b -> c -> c) -> c -> p a b -> c
  bifoldl :: forall a b c. (c -> a -> c) -> (c -> b -> c) -> c -> p a b -> c
  bifoldMap :: forall m a b. (Monoid m) => (a -> m) -> (b -> m) -> p a b -> m
```

`Bifoldable` represents data structures with two type arguments which can be
folded.

A fold for such a structure requires two step functions, one for each type
argument. Type class instances should choose the appropriate step function based
on the type of the element encountered at each point of the fold.


#### `bifold`

``` purescript
bifold :: forall t m. (Bifoldable t, Monoid m) => t m m -> m
```

Fold a data structure, accumulating values in a monoidal type.

#### `bitraverse_`

``` purescript
bitraverse_ :: forall t f a b c d. (Bifoldable t, Applicative f) => (a -> f c) -> (b -> f d) -> t a b -> f Unit
```

Traverse a data structure, accumulating effects using an `Applicative` functor,
ignoring the final result.

#### `bifor_`

``` purescript
bifor_ :: forall t f a b c d. (Bifoldable t, Applicative f) => t a b -> (a -> f c) -> (b -> f d) -> f Unit
```

A version of `bitraverse_` with the data structure as the first argument.

#### `bisequence_`

``` purescript
bisequence_ :: forall t f a b. (Bifoldable t, Applicative f) => t (f a) (f b) -> f Unit
```

Collapse a data structure, collecting effects using an `Applicative` functor,
ignoring the final result.

#### `biany`

``` purescript
biany :: forall t a b c. (Bifoldable t, BooleanAlgebra c) => (a -> c) -> (b -> c) -> t a b -> c
```

Test whether a predicate holds at any position in a data structure.

#### `biall`

``` purescript
biall :: forall t a b c. (Bifoldable t, BooleanAlgebra c) => (a -> c) -> (b -> c) -> t a b -> c
```


## Module Data.Bitraversable

#### `Bitraversable`

``` purescript
class (Bifunctor t, Bifoldable t) <= Bitraversable t where
  bitraverse :: forall f a b c d. (Applicative f) => (a -> f c) -> (b -> f d) -> t a b -> f (t c d)
  bisequence :: forall f a b. (Applicative f) => t (f a) (f b) -> f (t a b)
```

`Bitraversable` represents data structures with two type arguments which can be
traversed.

A traversal for such a structure requires two functions, one for each type
argument. Type class instances should choose the appropriate function based
on the type of the element encountered at each point of the traversal.


#### `bifor`

``` purescript
bifor :: forall t f a b c d. (Bitraversable t, Applicative f) => t a b -> (a -> f c) -> (b -> f d) -> f (t c d)
```

Traverse a data structure, accumulating effects and results using an `Applicative` functor.


## Module Control.Alt

This module defines the `Alt` type class.

#### `Alt`

``` purescript
class (Functor f) <= Alt f where
  alt :: forall a. f a -> f a -> f a
```

The `Alt` type class identifies an associative operation on a type
constructor.  It is similar to `Semigroup`, except that it applies to
types of kind `* -> *`, like `Array` or `List`, rather than concrete types
`String` or `Number`.

`Alt` instances are required to satisfy the following laws:

- Associativity: `(x <|> y) <|> z == x <|> (y <|> z)`
- Distributivity: `f <$> (x <|> y) == (f <$> x) <|> (f <$> y)`

For example, the `Array` (`[]`) type is an instance of `Alt`, where
`(<|>)` is defined to be concatenation.

##### Instances
``` purescript
instance altArray :: Alt Array
```

#### `(<|>)`

``` purescript
(<|>) :: forall f a. (Alt f) => f a -> f a -> f a
```

_left-associative / precedence 3_

An infix version of `alt`.


## Module Control.Plus

This module defines the `Plus` type class.

#### `Plus`

``` purescript
class (Alt f) <= Plus f where
  empty :: forall a. f a
```

The `Plus` type class extends the `Alt` type class with a value that
should be the left and right identity for `(<|>)`.

It is similar to `Monoid`, except that it applies to types of
kind `* -> *`, like `Array` or `List`, rather than concrete types like
`String` or `Number`.

`Plus` instances should satisfy the following laws:

- Left identity: `empty <|> x == x`
- Right identity: `x <|> empty == x`
- Annihilation: `f <$> empty == empty`

##### Instances
``` purescript
instance plusArray :: Plus Array
```


## Module Control.Alternative

This module defines the `Alternative` type class and associated
helper functions.

#### `Alternative`

``` purescript
class (Applicative f, Plus f) <= Alternative f
```

The `Alternative` type class has no members of its own; it just specifies
that the type constructor has both `Applicative` and `Plus` instances.

Types which have `Alternative` instances should also satisfy the following
laws:

- Distributivity: `(f <|> g) <*> x == (f <*> x) <|> (g <*> x)`
- Annihilation: `empty <*> f = empty`

##### Instances
``` purescript
instance alternativeArray :: Alternative Array
```


## Module Control.MonadPlus

This module defines the `MonadPlus` type class.

#### `MonadPlus`

``` purescript
class (Monad m, Alternative m) <= MonadPlus m
```

The `MonadPlus` type class has no members of its own; it just specifies
that the type has both `Monad` and `Alternative` instances.

Types which have `MonadPlus` instances should also satisfy the following
laws:

- Distributivity: `(x <|> y) >>= f == (x >>= f) <|> (y >>= f)`
- Annihilation: `empty >>= f = empty`

##### Instances
``` purescript
instance monadPlusArray :: MonadPlus Array
```

#### `guard`

``` purescript
guard :: forall m. (MonadPlus m) => Boolean -> m Unit
```

Fail using `Plus` if a condition does not hold, or
succeed using `Monad` if it does.

For example:

```purescript
import Data.Array

factors :: Number -> Array Number
factors n = do
  a <- 1 .. n
  b <- 1 .. a
  guard $ a * b == n
  return a
```


## Module Data.Maybe

#### `Maybe`

``` purescript
data Maybe a
  = Nothing
  | Just a
```

The `Maybe` type is used to represent optional values and can be seen as
something like a type-safe `null`, where `Nothing` is `null` and `Just x`
is the non-null value `x`.

##### Instances
``` purescript
instance functorMaybe :: Functor Maybe
instance applyMaybe :: Apply Maybe
instance applicativeMaybe :: Applicative Maybe
instance altMaybe :: Alt Maybe
instance plusMaybe :: Plus Maybe
instance alternativeMaybe :: Alternative Maybe
instance bindMaybe :: Bind Maybe
instance monadMaybe :: Monad Maybe
instance monadPlusMaybe :: MonadPlus Maybe
instance extendMaybe :: Extend Maybe
instance invariantMaybe :: Invariant Maybe
instance semigroupMaybe :: (Semigroup a) => Semigroup (Maybe a)
instance monoidMaybe :: (Semigroup a) => Monoid (Maybe a)
instance semiringMaybe :: (Semiring a) => Semiring (Maybe a)
instance moduloSemiringMaybe :: (ModuloSemiring a) => ModuloSemiring (Maybe a)
instance ringMaybe :: (Ring a) => Ring (Maybe a)
instance divisionRingMaybe :: (DivisionRing a) => DivisionRing (Maybe a)
instance numMaybe :: (Num a) => Num (Maybe a)
instance eqMaybe :: (Eq a) => Eq (Maybe a)
instance ordMaybe :: (Ord a) => Ord (Maybe a)
instance boundedMaybe :: (Bounded a) => Bounded (Maybe a)
instance boundedOrdMaybe :: (BoundedOrd a) => BoundedOrd (Maybe a)
instance booleanAlgebraMaybe :: (BooleanAlgebra a) => BooleanAlgebra (Maybe a)
instance showMaybe :: (Show a) => Show (Maybe a)
```

#### `maybe`

``` purescript
maybe :: forall a b. b -> (a -> b) -> Maybe a -> b
```

Takes a default value, a function, and a `Maybe` value. If the `Maybe`
value is `Nothing` the default value is returned, otherwise the function
is applied to the value inside the `Just` and the result is returned.

``` purescript
maybe x f Nothing == x
maybe x f (Just y) == f y
```

#### `maybe'`

``` purescript
maybe' :: forall a b. (Unit -> b) -> (a -> b) -> Maybe a -> b
```

Similar to `maybe` but for use in cases where the default value may be
expensive to compute. As PureScript is not lazy, the standard `maybe` has
to evaluate the default value before returning the result, whereas here
the value is only computed when the `Maybe` is known to be `Nothing`.

``` purescript
maybe' (\_ -> x) f Nothing == x
maybe' (\_ -> x) f (Just y) == f y
```

#### `fromMaybe`

``` purescript
fromMaybe :: forall a. a -> Maybe a -> a
```

Takes a default value, and a `Maybe` value. If the `Maybe` value is
`Nothing` the default value is returned, otherwise the value inside the
`Just` is returned.

``` purescript
fromMaybe x Nothing == x
fromMaybe x (Just y) == y
```

#### `fromMaybe'`

``` purescript
fromMaybe' :: forall a. (Unit -> a) -> Maybe a -> a
```

Similar to `fromMaybe` but for use in cases where the default value may be
expensive to compute. As PureScript is not lazy, the standard `fromMaybe`
has to evaluate the default value before returning the result, whereas here
the value is only computed when the `Maybe` is known to be `Nothing`.

``` purescript
fromMaybe' (\_ -> x) Nothing == x
fromMaybe' (\_ -> x) (Just y) == y
```

#### `isJust`

``` purescript
isJust :: forall a. Maybe a -> Boolean
```

Returns `true` when the `Maybe` value was constructed with `Just`.

#### `isNothing`

``` purescript
isNothing :: forall a. Maybe a -> Boolean
```

Returns `true` when the `Maybe` value is `Nothing`.


## Module Data.Array.ST

Helper functions for working with mutable arrays using the `ST` effect.

This module can be used when performance is important and mutation is a local effect.

#### `STArray`

``` purescript
data STArray :: * -> * -> *
```

A reference to a mutable array.

The first type parameter represents the memory region which the array belongs to.
The second type parameter defines the type of elements of the mutable array.

The runtime representation of a value of type `STArray h a` is the same as that of `[a]`,
except that mutation is allowed.

#### `Assoc`

``` purescript
type Assoc a = { value :: a, index :: Int }
```

An element and its index

#### `runSTArray`

``` purescript
runSTArray :: forall a r. (forall h. Eff (st :: ST h | r) (STArray h a)) -> Eff r (Array a)
```

Freeze a mutable array, creating an immutable array. Use this function as you would use
`runST` to freeze a mutable reference.

The rank-2 type prevents the reference from escaping the scope of `runSTArray`.

#### `emptySTArray`

``` purescript
emptySTArray :: forall a h r. Eff (st :: ST h | r) (STArray h a)
```

Create an empty mutable array.

#### `thaw`

``` purescript
thaw :: forall a h r. Array a -> Eff (st :: ST h | r) (STArray h a)
```

Create a mutable copy of an immutable array.

#### `freeze`

``` purescript
freeze :: forall a h r. STArray h a -> Eff (st :: ST h | r) (Array a)
```

Create an immutable copy of a mutable array.

#### `peekSTArray`

``` purescript
peekSTArray :: forall a h r. STArray h a -> Int -> Eff (st :: ST h | r) (Maybe a)
```

Read the value at the specified index in a mutable array.

#### `pokeSTArray`

``` purescript
pokeSTArray :: forall a h r. STArray h a -> Int -> a -> Eff (st :: ST h | r) Boolean
```

Change the value at the specified index in a mutable array.

#### `pushSTArray`

``` purescript
pushSTArray :: forall a h r. STArray h a -> a -> Eff (st :: ST h | r) Int
```

Append an element to the end of a mutable array.

#### `pushAllSTArray`

``` purescript
pushAllSTArray :: forall a h r. STArray h a -> Array a -> Eff (st :: ST h | r) Int
```

Append the values in an immutable array to the end of a mutable array.

#### `spliceSTArray`

``` purescript
spliceSTArray :: forall a h r. STArray h a -> Int -> Int -> Array a -> Eff (st :: ST h | r) (Array a)
```

Remove and/or insert elements from/into a mutable array at the specified index.

#### `toAssocArray`

``` purescript
toAssocArray :: forall a h r. STArray h a -> Eff (st :: ST h | r) (Array (Assoc a))
```

Create an immutable copy of a mutable array, where each element
is labelled with its index in the original array.


## Module Data.Maybe.First

#### `First`

``` purescript
newtype First a
  = First (Maybe a)
```

Monoid returning the first (left-most) non-`Nothing` value.

``` purescript
First (Just x) <> First (Just y) == First (Just x)
First Nothing <> First (Just y) == First (Just y)
First Nothing <> Nothing == First Nothing
mempty :: First _ == First Nothing
```

##### Instances
``` purescript
instance eqFirst :: (Eq a) => Eq (First a)
instance ordFirst :: (Ord a) => Ord (First a)
instance boundedFirst :: (Bounded a) => Bounded (First a)
instance functorFirst :: Functor First
instance applyFirst :: Apply First
instance applicativeFirst :: Applicative First
instance bindFirst :: Bind First
instance monadFirst :: Monad First
instance extendFirst :: Extend First
instance invariantFirst :: Invariant First
instance showFirst :: (Show a) => Show (First a)
instance semigroupFirst :: Semigroup (First a)
instance monoidFirst :: Monoid (First a)
```

#### `runFirst`

``` purescript
runFirst :: forall a. First a -> Maybe a
```


## Module Data.Maybe.Last

#### `Last`

``` purescript
newtype Last a
  = Last (Maybe a)
```

Monoid returning the last (right-most) non-`Nothing` value.

``` purescript
Last (Just x) <> Last (Just y) == Last (Just y)
Last (Just x) <> Nothing == Last (Just x)
Last Nothing <> Nothing == Last Nothing
mempty :: Last _ == Last Nothing
```

##### Instances
``` purescript
instance eqLast :: (Eq a) => Eq (Last a)
instance ordLast :: (Ord a) => Ord (Last a)
instance boundedLast :: (Bounded a) => Bounded (Last a)
instance functorLast :: Functor Last
instance applyLast :: Apply Last
instance applicativeLast :: Applicative Last
instance bindLast :: Bind Last
instance monadLast :: Monad Last
instance extendLast :: Extend Last
instance invariantLast :: Invariant Last
instance showLast :: (Show a) => Show (Last a)
instance semigroupLast :: Semigroup (Last a)
instance monoidLast :: Monoid (Last a)
```

#### `runLast`

``` purescript
runLast :: forall a. Last a -> Maybe a
```


## Module Data.Foldable

#### `Foldable`

``` purescript
class Foldable f where
  foldr :: forall a b. (a -> b -> b) -> b -> f a -> b
  foldl :: forall a b. (b -> a -> b) -> b -> f a -> b
  foldMap :: forall a m. (Monoid m) => (a -> m) -> f a -> m
```

`Foldable` represents data structures which can be _folded_.

- `foldr` folds a structure from the right
- `foldl` folds a structure from the left
- `foldMap` folds a structure by accumulating values in a `Monoid`

##### Instances
``` purescript
instance foldableArray :: Foldable Array
instance foldableMaybe :: Foldable Maybe
instance foldableFirst :: Foldable First
instance foldableLast :: Foldable Last
instance foldableAdditive :: Foldable Additive
instance foldableDual :: Foldable Dual
instance foldableDisj :: Foldable Disj
instance foldableConj :: Foldable Conj
instance foldableMultiplicative :: Foldable Multiplicative
```

#### `fold`

``` purescript
fold :: forall f m. (Foldable f, Monoid m) => f m -> m
```

Fold a data structure, accumulating values in some `Monoid`.

#### `traverse_`

``` purescript
traverse_ :: forall a b f m. (Applicative m, Foldable f) => (a -> m b) -> f a -> m Unit
```

Traverse a data structure, performing some effects encoded by an
`Applicative` functor at each value, ignoring the final result.

For example:

```purescript
traverse_ print [1, 2, 3]
```

#### `for_`

``` purescript
for_ :: forall a b f m. (Applicative m, Foldable f) => f a -> (a -> m b) -> m Unit
```

A version of `traverse_` with its arguments flipped.

This can be useful when running an action written using do notation
for every element in a data structure:

For example:

```purescript
for_ [1, 2, 3] \n -> do
  print n
  trace "squared is"
  print (n * n)
```

#### `sequence_`

``` purescript
sequence_ :: forall a f m. (Applicative m, Foldable f) => f (m a) -> m Unit
```

Perform all of the effects in some data structure in the order
given by the `Foldable` instance, ignoring the final result.

For example:

```purescript
sequence_ [ trace "Hello, ", trace " world!" ]
```

#### `mconcat`

``` purescript
mconcat :: forall f m. (Foldable f, Monoid m) => f m -> m
```

Fold a data structure, accumulating values in some `Monoid`.

#### `intercalate`

``` purescript
intercalate :: forall f m. (Foldable f, Monoid m) => m -> f m -> m
```

Fold a data structure, accumulating values in some `Monoid`,
combining adjacent elements using the specified separator.

#### `and`

``` purescript
and :: forall a f. (Foldable f, BooleanAlgebra a) => f a -> a
```

Test whether all `Boolean` values in a data structure are `true`.

#### `or`

``` purescript
or :: forall a f. (Foldable f, BooleanAlgebra a) => f a -> a
```

Test whether any `Boolean` value in a data structure is `true`.

#### `any`

``` purescript
any :: forall a b f. (Foldable f, BooleanAlgebra b) => (a -> b) -> f a -> b
```

Test whether a predicate holds for any element in a data structure.

#### `all`

``` purescript
all :: forall a b f. (Foldable f, BooleanAlgebra b) => (a -> b) -> f a -> b
```

Test whether a predicate holds for all elements in a data structure.

#### `sum`

``` purescript
sum :: forall a f. (Foldable f, Semiring a) => f a -> a
```

Find the sum of the numeric values in a data structure.

#### `product`

``` purescript
product :: forall a f. (Foldable f, Semiring a) => f a -> a
```

Find the product of the numeric values in a data structure.

#### `elem`

``` purescript
elem :: forall a f. (Foldable f, Eq a) => a -> f a -> Boolean
```

Test whether a value is an element of a data structure.

#### `notElem`

``` purescript
notElem :: forall a f. (Foldable f, Eq a) => a -> f a -> Boolean
```

Test whether a value is not an element of a data structure.

#### `find`

``` purescript
find :: forall a f. (Foldable f) => (a -> Boolean) -> f a -> Maybe a
```

Try to find an element in a data structure which satisfies a predicate.


## Module Data.Maybe.Unsafe

#### `fromJust`

``` purescript
fromJust :: forall a. Maybe a -> a
```

A partial function that extracts the value from the `Just` data
constructor. Passing `Nothing` to `fromJust` will throw an error at
runtime.

#### `unsafeThrow`

``` purescript
unsafeThrow :: forall a. String -> a
```


## Module Data.Int

#### `fromNumber`

``` purescript
fromNumber :: Number -> Maybe Int
```

Creates an `Int` from a `Number` value. The number must already be an
integer and fall within the valid range of values for the `Int` type
otherwise `Nothing` is returned.

#### `floor`

``` purescript
floor :: Number -> Int
```

Convert a `Number` to an `Int`, by taking the closest integer equal to or
less than the argument. Values outside the `Int` range are clamped.

#### `ceil`

``` purescript
ceil :: Number -> Int
```

Convert a `Number` to an `Int`, by taking the closest integer equal to or
greater than the argument. Values outside the `Int` range are clamped.

#### `round`

``` purescript
round :: Number -> Int
```

Convert a `Number` to an `Int`, by taking the nearest integer to the
argument. Values outside the `Int` range are clamped.

#### `toNumber`

``` purescript
toNumber :: Int -> Number
```

Converts an `Int` value back into a `Number`. Any `Int` is a valid `Number`
so there is no loss of precision with this function.

#### `fromString`

``` purescript
fromString :: String -> Maybe Int
```

Reads an `Int` from a `String` value. The number must parse as an integer
and fall within the valid range of values for the `Int` type, otherwise
`Nothing` is returned.

#### `even`

``` purescript
even :: Int -> Boolean
```

Returns whether an `Int` is an even number.

``` purescript
even 0 == true
even 1 == false
```

#### `odd`

``` purescript
odd :: Int -> Boolean
```

The negation of `even`.

``` purescript
odd 0 == false
odd 1 == false
```


## Module Data.String

Wraps the functions of Javascript's `String` object.
A String represents a sequence of characters.
For details of the underlying implementation, see [String Reference at MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String).

#### `charAt`

``` purescript
charAt :: Int -> String -> Maybe Char
```

Returns the character at the given index, if the index is within bounds.

#### `fromChar`

``` purescript
fromChar :: Char -> String
```

Returns a string of length `1` containing the given character.

#### `singleton`

``` purescript
singleton :: Char -> String
```

Returns a string of length `1` containing the given character.
Same as `fromChar`.

#### `charCodeAt`

``` purescript
charCodeAt :: Int -> String -> Maybe Int
```

Returns the numeric Unicode value of the character at the given index,
if the index is within bounds.

#### `toChar`

``` purescript
toChar :: String -> Maybe Char
```

#### `null`

``` purescript
null :: String -> Boolean
```

Returns `true` if the given string is empty.

#### `uncons`

``` purescript
uncons :: String -> Maybe { head :: Char, tail :: String }
```

Returns the first character and the rest of the string,
if the string is not empty.

#### `takeWhile`

``` purescript
takeWhile :: (Char -> Boolean) -> String -> String
```

Returns the longest prefix (possibly empty) of characters that satisfy
the predicate:

#### `dropWhile`

``` purescript
dropWhile :: (Char -> Boolean) -> String -> String
```

Returns the suffix remaining after `takeWhile`.

#### `stripPrefix`

``` purescript
stripPrefix :: String -> String -> Maybe String
```

If the string starts with the given prefix, return the portion of the
string left after removing it, as a Just value. Otherwise, return Nothing.
* `stripPrefix "http:" "http://purescript.org" == Just "//purescript.org"`
* `stripPrefix "http:" "https://purescript.org" == Nothing`

#### `stripSuffix`

``` purescript
stripSuffix :: String -> String -> Maybe String
```

If the string ends with the given suffix, return the portion of the
string left after removing it, as a Just value. Otherwise, return Nothing.
* `stripSuffix ".exe" "psc.exe" == Just "psc"`
* `stripSuffix ".exe" "psc" == Nothing`

#### `fromCharArray`

``` purescript
fromCharArray :: Array Char -> String
```

Converts an array of characters into a string.

#### `contains`

``` purescript
contains :: String -> String -> Boolean
```

Checks whether the first string exists in the second string.

#### `indexOf`

``` purescript
indexOf :: String -> String -> Maybe Int
```

Returns the index of the first occurrence of the first string in the
second string. Returns `Nothing` if there is no match.

#### `indexOf'`

``` purescript
indexOf' :: String -> Int -> String -> Maybe Int
```

Returns the index of the first occurrence of the first string in the
second string, starting at the given index. Returns `Nothing` if there is
no match.

#### `lastIndexOf`

``` purescript
lastIndexOf :: String -> String -> Maybe Int
```

Returns the index of the last occurrence of the first string in the
second string. Returns `Nothing` if there is no match.

#### `lastIndexOf'`

``` purescript
lastIndexOf' :: String -> Int -> String -> Maybe Int
```

Returns the index of the last occurrence of the first string in the
second string, starting at the given index. Returns `Nothing` if there is
no match.

#### `length`

``` purescript
length :: String -> Int
```

Returns the number of characters the string is composed of.

#### `localeCompare`

``` purescript
localeCompare :: String -> String -> Ordering
```

Locale-aware sort order comparison.

#### `replace`

``` purescript
replace :: String -> String -> String -> String
```

Replaces the first occurence of the first argument with the second argument.

#### `take`

``` purescript
take :: Int -> String -> String
```

Returns the first `n` characters of the string.

#### `drop`

``` purescript
drop :: Int -> String -> String
```

Returns the string without the first `n` characters.

#### `count`

``` purescript
count :: (Char -> Boolean) -> String -> Int
```

Returns the number of contiguous characters at the beginning
of the string for which the predicate holds.

#### `split`

``` purescript
split :: String -> String -> Array String
```

Returns the substrings of the second string separated along occurences
of the first string.
* `split " " "hello world" == ["hello", "world"]`

#### `toCharArray`

``` purescript
toCharArray :: String -> Array Char
```

Converts the string into an array of characters.

#### `toLower`

``` purescript
toLower :: String -> String
```

Returns the argument converted to lowercase.

#### `toUpper`

``` purescript
toUpper :: String -> String
```

Returns the argument converted to uppercase.

#### `trim`

``` purescript
trim :: String -> String
```

Removes whitespace from the beginning and end of a string, including
[whitespace characters](http://www.ecma-international.org/ecma-262/5.1/#sec-7.2)
and [line terminators](http://www.ecma-international.org/ecma-262/5.1/#sec-7.3).

#### `joinWith`

``` purescript
joinWith :: String -> Array String -> String
```

Joins the strings in the array together, inserting the first argument
as separator between them.


## Module Data.String.Regex

Wraps Javascript's `RegExp` object that enables matching strings with
patternes defined by regular expressions.
For details of the underlying implementation, see [RegExp Reference at MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp).

#### `Regex`

``` purescript
data Regex :: *
```

Wraps Javascript `RegExp` objects.

##### Instances
``` purescript
instance showRegex :: Show Regex
```

#### `RegexFlags`

``` purescript
type RegexFlags = { global :: Boolean, ignoreCase :: Boolean, multiline :: Boolean, sticky :: Boolean, unicode :: Boolean }
```

Flags that control matching.

#### `noFlags`

``` purescript
noFlags :: RegexFlags
```

All flags set to false.

#### `regex`

``` purescript
regex :: String -> RegexFlags -> Regex
```

Constructs a `Regex` from a pattern string and flags.

#### `source`

``` purescript
source :: Regex -> String
```

Returns the pattern string used to construct the given `Regex`.

#### `flags`

``` purescript
flags :: Regex -> RegexFlags
```

Returns the `RegexFlags` used to construct the given `Regex`.

#### `renderFlags`

``` purescript
renderFlags :: RegexFlags -> String
```

Returns the string representation of the given `RegexFlags`.

#### `parseFlags`

``` purescript
parseFlags :: String -> RegexFlags
```

Parses the string representation of `RegexFlags`.

#### `test`

``` purescript
test :: Regex -> String -> Boolean
```

Returns `true` if the `Regex` matches the string.

#### `match`

``` purescript
match :: Regex -> String -> Maybe (Array (Maybe String))
```

Matches the string against the `Regex` and returns an array of matches
if there were any. Each match has type `Maybe String`, where `Nothing`
represents an unmatched optional capturing group.
See [reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/match).

#### `replace`

``` purescript
replace :: Regex -> String -> String -> String
```

Replaces occurences of the `Regex` with the first string. The replacement
string can include special replacement patterns escaped with `"$"`.
See [reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace).

#### `replace'`

``` purescript
replace' :: Regex -> (String -> Array String -> String) -> String -> String
```

Transforms occurences of the `Regex` using a function of the matched
substring and a list of submatch strings.
See the [reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/replace#Specifying_a_function_as_a_parameter).

#### `search`

``` purescript
search :: Regex -> String -> Maybe Int
```

Returns `Just` the index of the first match of the `Regex` in the string,
or `Nothing` if there is no match.

#### `split`

``` purescript
split :: Regex -> String -> Array String
```

Split the string into an array of substrings along occurences of the `Regex`.


## Module Data.Traversable

#### `Traversable`

``` purescript
class (Functor t, Foldable t) <= Traversable t where
  traverse :: forall a b m. (Applicative m) => (a -> m b) -> t a -> m (t b)
  sequence :: forall a m. (Applicative m) => t (m a) -> m (t a)
```

`Traversable` represents data structures which can be _traversed_,
accumulating results and effects in some `Applicative` functor.

- `traverse` runs an action for every element in a data structure,
  and accumulates the results.
- `sequence` runs the actions _contained_ in a data structure,
  and accumulates the results.

The `traverse` and `sequence` functions should be compatible in the
following sense:

- `traverse f xs = sequence (f <$> xs)`
- `sequence = traverse id`

`Traversable` instances should also be compatible with the corresponding
`Foldable` instances, in the following sense:

- `foldMap f = runConst <<< traverse (Const <<< f)`

##### Instances
``` purescript
instance traversableArray :: Traversable Array
instance traversableMaybe :: Traversable Maybe
instance traversableFirst :: Traversable First
instance traversableLast :: Traversable Last
instance traversableAdditive :: Traversable Additive
instance traversableDual :: Traversable Dual
instance traversableConj :: Traversable Conj
instance traversableDisj :: Traversable Disj
instance traversableMultiplicative :: Traversable Multiplicative
```

#### `for`

``` purescript
for :: forall a b m t. (Applicative m, Traversable t) => t a -> (a -> m b) -> m (t b)
```

A version of `traverse` with its arguments flipped.


This can be useful when running an action written using do notation
for every element in a data structure:

For example:

```purescript
for [1, 2, 3] \n -> do
  print n
  return (n * n)
```

#### `Accum`

``` purescript
type Accum s a = { accum :: s, value :: a }
```

#### `scanl`

``` purescript
scanl :: forall a b f. (Traversable f) => (b -> a -> b) -> b -> f a -> f b
```

Fold a data structure from the left, keeping all intermediate results
instead of only the final result.

#### `mapAccumL`

``` purescript
mapAccumL :: forall a b s f. (Traversable f) => (s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
```

Fold a data structure from the left, keeping all intermediate results
instead of only the final result.

Unlike `scanl`, `mapAccumL` allows the type of accumulator to differ
from the element type of the final data structure.

#### `scanr`

``` purescript
scanr :: forall a b f. (Traversable f) => (a -> b -> b) -> b -> f a -> f b
```

Fold a data structure from the right, keeping all intermediate results
instead of only the final result.

#### `mapAccumR`

``` purescript
mapAccumR :: forall a b s f. (Traversable f) => (s -> a -> Accum s b) -> s -> f a -> Accum s (f b)
```

Fold a data structure from the right, keeping all intermediate results
instead of only the final result.

Unlike `scanr`, `mapAccumR` allows the type of accumulator to differ
from the element type of the final data structure.


## Module Data.Either

#### `Either`

``` purescript
data Either a b
  = Left a
  | Right b
```

The `Either` type is used to represent a choice between two types of value.

A common use case for `Either` is error handling, where `Left` is used to
carry an error value and `Right` is used to carry a success value.

##### Instances
``` purescript
instance functorEither :: Functor (Either a)
instance bifunctorEither :: Bifunctor Either
instance applyEither :: Apply (Either e)
instance applicativeEither :: Applicative (Either e)
instance altEither :: Alt (Either e)
instance bindEither :: Bind (Either e)
instance monadEither :: Monad (Either e)
instance extendEither :: Extend (Either e)
instance showEither :: (Show a, Show b) => Show (Either a b)
instance eqEither :: (Eq a, Eq b) => Eq (Either a b)
instance ordEither :: (Ord a, Ord b) => Ord (Either a b)
instance boundedEither :: (Bounded a, Bounded b) => Bounded (Either a b)
instance foldableEither :: Foldable (Either a)
instance bifoldableEither :: Bifoldable Either
instance traversableEither :: Traversable (Either a)
instance bitraversableEither :: Bitraversable Either
instance semiringEither :: (Semiring b) => Semiring (Either a b)
instance semigroupEither :: (Semigroup b) => Semigroup (Either a b)
```

#### `either`

``` purescript
either :: forall a b c. (a -> c) -> (b -> c) -> Either a b -> c
```

Takes two functions and an `Either` value, if the value is a `Left` the
inner value is applied to the first function, if the value is a `Right`
the inner value is applied to the second function.

``` purescript
either f g (Left x) == f x
either f g (Right y) == g y
```

#### `isLeft`

``` purescript
isLeft :: forall a b. Either a b -> Boolean
```

Returns `true` when the `Either` value was constructed with `Left`.

#### `isRight`

``` purescript
isRight :: forall a b. Either a b -> Boolean
```

Returns `true` when the `Either` value was constructed with `Right`.


## Module Data.Either.Nested

Utilities for n-eithers: sums types with more than two terms built from nested eithers.

Nested eithers arise naturally in sum combinators. You shouldn't
represent sum data using nested eithers, but if combinators you're working with
create them, utilities in this module will allow to to more easily work
with them, including translating to and from more traditional sum types.

```purescript
data Color = Red Number | Green Number | Blue Number

toEither3 :: Color -> Either3 Number Number Number
toEither3 = either3 Red Green Blue

fromEither3 :: Either3 Number Number Number -> Color
fromEither3 (Red   v) = either1of3
fromEither3 (Green v) = either2of3
fromEither3 (Blue  v) = either3of3
```

#### `Either2`

``` purescript
type Either2 a z = Either a z
```

#### `Either3`

``` purescript
type Either3 a b z = Either (Either2 a b) z
```

#### `Either4`

``` purescript
type Either4 a b c z = Either (Either3 a b c) z
```

#### `Either5`

``` purescript
type Either5 a b c d z = Either (Either4 a b c d) z
```

#### `Either6`

``` purescript
type Either6 a b c d e z = Either (Either5 a b c d e) z
```

#### `Either7`

``` purescript
type Either7 a b c d e f z = Either (Either6 a b c d e f) z
```

#### `Either8`

``` purescript
type Either8 a b c d e f g z = Either (Either7 a b c d e f g) z
```

#### `Either9`

``` purescript
type Either9 a b c d e f g h z = Either (Either8 a b c d e f g h) z
```

#### `Either10`

``` purescript
type Either10 a b c d e f g h i z = Either (Either9 a b c d e f g h i) z
```

#### `either1of2`

``` purescript
either1of2 :: forall a b. a -> Either2 a b
```

#### `either2of2`

``` purescript
either2of2 :: forall a b. b -> Either2 a b
```

#### `either1of3`

``` purescript
either1of3 :: forall a b c. a -> Either3 a b c
```

#### `either2of3`

``` purescript
either2of3 :: forall a b c. b -> Either3 a b c
```

#### `either3of3`

``` purescript
either3of3 :: forall a b c. c -> Either3 a b c
```

#### `either1of4`

``` purescript
either1of4 :: forall a b c d. a -> Either4 a b c d
```

#### `either2of4`

``` purescript
either2of4 :: forall a b c d. b -> Either4 a b c d
```

#### `either3of4`

``` purescript
either3of4 :: forall a b c d. c -> Either4 a b c d
```

#### `either4of4`

``` purescript
either4of4 :: forall a b c d. d -> Either4 a b c d
```

#### `either1of5`

``` purescript
either1of5 :: forall a b c d e. a -> Either5 a b c d e
```

#### `either2of5`

``` purescript
either2of5 :: forall a b c d e. b -> Either5 a b c d e
```

#### `either3of5`

``` purescript
either3of5 :: forall a b c d e. c -> Either5 a b c d e
```

#### `either4of5`

``` purescript
either4of5 :: forall a b c d e. d -> Either5 a b c d e
```

#### `either5of5`

``` purescript
either5of5 :: forall a b c d e. e -> Either5 a b c d e
```

#### `either1of6`

``` purescript
either1of6 :: forall a b c d e f. a -> Either6 a b c d e f
```

#### `either2of6`

``` purescript
either2of6 :: forall a b c d e f. b -> Either6 a b c d e f
```

#### `either3of6`

``` purescript
either3of6 :: forall a b c d e f. c -> Either6 a b c d e f
```

#### `either4of6`

``` purescript
either4of6 :: forall a b c d e f. d -> Either6 a b c d e f
```

#### `either5of6`

``` purescript
either5of6 :: forall a b c d e f. e -> Either6 a b c d e f
```

#### `either6of6`

``` purescript
either6of6 :: forall a b c d e f. f -> Either6 a b c d e f
```

#### `either1of7`

``` purescript
either1of7 :: forall a b c d e f g. a -> Either7 a b c d e f g
```

#### `either2of7`

``` purescript
either2of7 :: forall a b c d e f g. b -> Either7 a b c d e f g
```

#### `either3of7`

``` purescript
either3of7 :: forall a b c d e f g. c -> Either7 a b c d e f g
```

#### `either4of7`

``` purescript
either4of7 :: forall a b c d e f g. d -> Either7 a b c d e f g
```

#### `either5of7`

``` purescript
either5of7 :: forall a b c d e f g. e -> Either7 a b c d e f g
```

#### `either6of7`

``` purescript
either6of7 :: forall a b c d e f g. f -> Either7 a b c d e f g
```

#### `either7of7`

``` purescript
either7of7 :: forall a b c d e f g. g -> Either7 a b c d e f g
```

#### `either1of8`

``` purescript
either1of8 :: forall a b c d e f g h. a -> Either8 a b c d e f g h
```

#### `either2of8`

``` purescript
either2of8 :: forall a b c d e f g h. b -> Either8 a b c d e f g h
```

#### `either3of8`

``` purescript
either3of8 :: forall a b c d e f g h. c -> Either8 a b c d e f g h
```

#### `either4of8`

``` purescript
either4of8 :: forall a b c d e f g h. d -> Either8 a b c d e f g h
```

#### `either5of8`

``` purescript
either5of8 :: forall a b c d e f g h. e -> Either8 a b c d e f g h
```

#### `either6of8`

``` purescript
either6of8 :: forall a b c d e f g h. f -> Either8 a b c d e f g h
```

#### `either7of8`

``` purescript
either7of8 :: forall a b c d e f g h. g -> Either8 a b c d e f g h
```

#### `either8of8`

``` purescript
either8of8 :: forall a b c d e f g h. h -> Either8 a b c d e f g h
```

#### `either1of9`

``` purescript
either1of9 :: forall a b c d e f g h i. a -> Either9 a b c d e f g h i
```

#### `either2of9`

``` purescript
either2of9 :: forall a b c d e f g h i. b -> Either9 a b c d e f g h i
```

#### `either3of9`

``` purescript
either3of9 :: forall a b c d e f g h i. c -> Either9 a b c d e f g h i
```

#### `either4of9`

``` purescript
either4of9 :: forall a b c d e f g h i. d -> Either9 a b c d e f g h i
```

#### `either5of9`

``` purescript
either5of9 :: forall a b c d e f g h i. e -> Either9 a b c d e f g h i
```

#### `either6of9`

``` purescript
either6of9 :: forall a b c d e f g h i. f -> Either9 a b c d e f g h i
```

#### `either7of9`

``` purescript
either7of9 :: forall a b c d e f g h i. g -> Either9 a b c d e f g h i
```

#### `either8of9`

``` purescript
either8of9 :: forall a b c d e f g h i. h -> Either9 a b c d e f g h i
```

#### `either9of9`

``` purescript
either9of9 :: forall a b c d e f g h i. i -> Either9 a b c d e f g h i
```

#### `either1of10`

``` purescript
either1of10 :: forall a b c d e f g h i j. a -> Either10 a b c d e f g h i j
```

#### `either2of10`

``` purescript
either2of10 :: forall a b c d e f g h i j. b -> Either10 a b c d e f g h i j
```

#### `either3of10`

``` purescript
either3of10 :: forall a b c d e f g h i j. c -> Either10 a b c d e f g h i j
```

#### `either4of10`

``` purescript
either4of10 :: forall a b c d e f g h i j. d -> Either10 a b c d e f g h i j
```

#### `either5of10`

``` purescript
either5of10 :: forall a b c d e f g h i j. e -> Either10 a b c d e f g h i j
```

#### `either6of10`

``` purescript
either6of10 :: forall a b c d e f g h i j. f -> Either10 a b c d e f g h i j
```

#### `either7of10`

``` purescript
either7of10 :: forall a b c d e f g h i j. g -> Either10 a b c d e f g h i j
```

#### `either8of10`

``` purescript
either8of10 :: forall a b c d e f g h i j. h -> Either10 a b c d e f g h i j
```

#### `either9of10`

``` purescript
either9of10 :: forall a b c d e f g h i j. i -> Either10 a b c d e f g h i j
```

#### `either10of10`

``` purescript
either10of10 :: forall a b c d e f g h i j. j -> Either10 a b c d e f g h i j
```

#### `either2`

``` purescript
either2 :: forall a b z. (a -> z) -> (b -> z) -> Either2 a b -> z
```

#### `either3`

``` purescript
either3 :: forall a b c z. (a -> z) -> (b -> z) -> (c -> z) -> Either3 a b c -> z
```

#### `either4`

``` purescript
either4 :: forall a b c d z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> Either4 a b c d -> z
```

#### `either5`

``` purescript
either5 :: forall a b c d e z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> (e -> z) -> Either5 a b c d e -> z
```

#### `either6`

``` purescript
either6 :: forall a b c d e f z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> (e -> z) -> (f -> z) -> Either6 a b c d e f -> z
```

#### `either7`

``` purescript
either7 :: forall a b c d e f g z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> (e -> z) -> (f -> z) -> (g -> z) -> Either7 a b c d e f g -> z
```

#### `either8`

``` purescript
either8 :: forall a b c d e f g h z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> (e -> z) -> (f -> z) -> (g -> z) -> (h -> z) -> Either8 a b c d e f g h -> z
```

#### `either9`

``` purescript
either9 :: forall a b c d e f g h i z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> (e -> z) -> (f -> z) -> (g -> z) -> (h -> z) -> (i -> z) -> Either9 a b c d e f g h i -> z
```

#### `either10`

``` purescript
either10 :: forall a b c d e f g h i j z. (a -> z) -> (b -> z) -> (c -> z) -> (d -> z) -> (e -> z) -> (f -> z) -> (g -> z) -> (h -> z) -> (i -> z) -> (j -> z) -> Either10 a b c d e f g h i j -> z
```


## Module Data.Either.Unsafe

#### `fromLeft`

``` purescript
fromLeft :: forall a b. Either a b -> a
```

A partial function that extracts the value from the `Left` data constructor.
Passing a `Right` to `fromLeft` will throw an error at runtime.

#### `fromRight`

``` purescript
fromRight :: forall a b. Either a b -> b
```

A partial function that extracts the value from the `Right` data constructor.
Passing a `Left` to `fromRight` will throw an error at runtime.


## Module Data.Foreign

This module defines types and functions for working with _foreign_
data.

#### `Foreign`

``` purescript
data Foreign :: *
```

A type for _foreign data_.

Foreign data is data from any external _unknown_ or _unreliable_
source, for which it cannot be guaranteed that the runtime representation
conforms to that of any particular type.

Suitable applications of `Foreign` are

- To represent responses from web services
- To integrate with external JavaScript libraries.

#### `ForeignError`

``` purescript
data ForeignError
  = TypeMismatch String String
  | ErrorAtIndex Int ForeignError
  | ErrorAtProperty String ForeignError
  | JSONError String
```

A type for runtime type errors

##### Instances
``` purescript
instance showForeignError :: Show ForeignError
instance eqForeignError :: Eq ForeignError
```

#### `F`

``` purescript
type F = Either ForeignError
```

An error monad, used in this library to encode possible failure when
dealing with foreign data.

#### `parseJSON`

``` purescript
parseJSON :: String -> F Foreign
```

Attempt to parse a JSON string, returning the result as foreign data.

#### `toForeign`

``` purescript
toForeign :: forall a. a -> Foreign
```

Coerce any value to the a `Foreign` value.

#### `unsafeFromForeign`

``` purescript
unsafeFromForeign :: forall a. Foreign -> a
```

Unsafely coerce a `Foreign` value.

#### `typeOf`

``` purescript
typeOf :: Foreign -> String
```

Read the Javascript _type_ of a value

#### `tagOf`

``` purescript
tagOf :: Foreign -> String
```

Read the Javascript _tag_ of a value.

This function wraps the `Object.toString` method.

#### `unsafeReadTagged`

``` purescript
unsafeReadTagged :: forall a. String -> Foreign -> F a
```

Unsafely coerce a `Foreign` value when the value has a particular `tagOf`
value.

#### `isNull`

``` purescript
isNull :: Foreign -> Boolean
```

Test whether a foreign value is null

#### `isUndefined`

``` purescript
isUndefined :: Foreign -> Boolean
```

Test whether a foreign value is undefined

#### `isArray`

``` purescript
isArray :: Foreign -> Boolean
```

Test whether a foreign value is an array

#### `readString`

``` purescript
readString :: Foreign -> F String
```

Attempt to coerce a foreign value to a `String`.

#### `readChar`

``` purescript
readChar :: Foreign -> F Char
```

Attempt to coerce a foreign value to a `Char`.

#### `readBoolean`

``` purescript
readBoolean :: Foreign -> F Boolean
```

Attempt to coerce a foreign value to a `Boolean`.

#### `readNumber`

``` purescript
readNumber :: Foreign -> F Number
```

Attempt to coerce a foreign value to a `Number`.

#### `readInt`

``` purescript
readInt :: Foreign -> F Int
```

Attempt to coerce a foreign value to an `Int`.

#### `readArray`

``` purescript
readArray :: Foreign -> F (Array Foreign)
```

Attempt to coerce a foreign value to an array.


## Module Data.Foreign.Null

#### `Null`

``` purescript
newtype Null a
  = Null (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
null values.

Conceptually, this type represents values which may be `null`,
but not `undefined`.

#### `runNull`

``` purescript
runNull :: forall a. Null a -> Maybe a
```

Unwrap a `Null` value

#### `readNull`

``` purescript
readNull :: forall a. (Foreign -> F a) -> Foreign -> F (Null a)
```

Read a `Null` value


## Module Data.Foreign.NullOrUndefined

#### `NullOrUndefined`

``` purescript
newtype NullOrUndefined a
  = NullOrUndefined (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
null and undefined values.

Conceptually, this type represents values which may be `null`
or `undefined`.

#### `runNullOrUndefined`

``` purescript
runNullOrUndefined :: forall a. NullOrUndefined a -> Maybe a
```

Unwrap a `NullOrUndefined` value

#### `readNullOrUndefined`

``` purescript
readNullOrUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (NullOrUndefined a)
```

Read a `NullOrUndefined` value


## Module Data.Foreign.Undefined

#### `Undefined`

``` purescript
newtype Undefined a
  = Undefined (Maybe a)
```

A `newtype` wrapper whose `IsForeign` instance correctly handles
undefined values.

Conceptually, this type represents values which may be `undefined`,
but not `null`.

#### `runUndefined`

``` purescript
runUndefined :: forall a. Undefined a -> Maybe a
```

Unwrap an `Undefined` value

#### `readUndefined`

``` purescript
readUndefined :: forall a. (Foreign -> F a) -> Foreign -> F (Undefined a)
```

Read an `Undefined` value


## Module Graphics.D3.Selection

#### `Selection`

``` purescript
data Selection :: * -> *
```

##### Instances
``` purescript
instance appendableSelection :: Appendable Selection
instance existingSelection :: Existing Selection
instance clickableSelection :: Clickable (Selection a)
```

#### `Update`

``` purescript
data Update :: * -> *
```

##### Instances
``` purescript
instance appendableUpdate :: Appendable Update
instance existingUpdate :: Existing Update
```

#### `Enter`

``` purescript
data Enter :: * -> *
```

##### Instances
``` purescript
instance appendableEnter :: Appendable Enter
```

#### `Transition`

``` purescript
data Transition :: * -> *
```

##### Instances
``` purescript
instance existingTransition :: Existing Transition
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
class AttrValue a
```

##### Instances
``` purescript
instance attrValNumber :: AttrValue Number
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

#### `bind_`

``` purescript
bind_ :: forall oldData newData. Array newData -> Selection oldData -> D3Eff (Update newData)
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

##### Instances
``` purescript
instance appendableSelection :: Appendable Selection
instance appendableUpdate :: Appendable Update
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

##### Instances
``` purescript
instance existingSelection :: Existing Selection
instance existingUpdate :: Existing Update
instance existingTransition :: Existing Transition
```

#### `Clickable`

``` purescript
class Clickable c where
  onClick :: forall eff r. (Foreign -> Eff eff r) -> c -> D3Eff c
  onDoubleClick :: forall eff r. (Foreign -> Eff eff r) -> c -> D3Eff c
```

##### Instances
``` purescript
instance clickableSelection :: Clickable (Selection a)
```


## Module Data.Foreign.Index

This module defines a type class for types which act like
_property indices_.

#### `Index`

``` purescript
class Index i where
  ix :: Foreign -> i -> F Foreign
  hasProperty :: i -> Foreign -> Boolean
  hasOwnProperty :: i -> Foreign -> Boolean
  errorAt :: i -> ForeignError -> ForeignError
```

This type class identifies types wich act like _property indices_.

The canonical instances are for `String`s and `Number`s.

##### Instances
``` purescript
instance indexString :: Index String
instance indexInt :: Index Int
```

#### `(!)`

``` purescript
(!) :: forall i. (Index i) => Foreign -> i -> F Foreign
```

_left-associative / precedence 9_

An infix alias for `ix`.

#### `prop`

``` purescript
prop :: String -> Foreign -> F Foreign
```

Attempt to read a value from a foreign value property

#### `index`

``` purescript
index :: Int -> Foreign -> F Foreign
```

Attempt to read a value from a foreign value at the specified numeric index


## Module Data.Foreign.Keys

This module provides functions for working with object properties
of Javascript objects.

#### `keys`

``` purescript
keys :: Foreign -> F (Array String)
```

Get an array of the properties defined on a foreign value


## Module Graphics.D3.Request

#### `RequestError`

``` purescript
type RequestError = { status :: Number, statusText :: String }
```

#### `csv`

``` purescript
csv :: forall e a. String -> (Either RequestError (Array Foreign) -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
```

#### `tsv`

``` purescript
tsv :: forall e a. String -> (Either RequestError (Array Foreign) -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
```

#### `json`

``` purescript
json :: forall e a. String -> (Either RequestError Foreign -> Eff (d3 :: D3 | e) a) -> D3Eff Unit
```


## Module Data.Tuple

A data type and functions for working with ordered pairs.

#### `Tuple`

``` purescript
data Tuple a b
  = Tuple a b
```

A simple product type for wrapping a pair of component values.

##### Instances
``` purescript
instance showTuple :: (Show a, Show b) => Show (Tuple a b)
instance eqTuple :: (Eq a, Eq b) => Eq (Tuple a b)
instance ordTuple :: (Ord a, Ord b) => Ord (Tuple a b)
instance boundedTuple :: (Bounded a, Bounded b) => Bounded (Tuple a b)
instance boundedOrdTuple :: (BoundedOrd a, BoundedOrd b) => BoundedOrd (Tuple a b)
instance semigroupoidTuple :: Semigroupoid Tuple
instance semigroupTuple :: (Semigroup a, Semigroup b) => Semigroup (Tuple a b)
instance monoidTuple :: (Monoid a, Monoid b) => Monoid (Tuple a b)
instance semiringTuple :: (Semiring a, Semiring b) => Semiring (Tuple a b)
instance moduloSemiringTuple :: (ModuloSemiring a, ModuloSemiring b) => ModuloSemiring (Tuple a b)
instance ringTuple :: (Ring a, Ring b) => Ring (Tuple a b)
instance divisionRingTuple :: (DivisionRing a, DivisionRing b) => DivisionRing (Tuple a b)
instance numTuple :: (Num a, Num b) => Num (Tuple a b)
instance booleanAlgebraTuple :: (BooleanAlgebra a, BooleanAlgebra b) => BooleanAlgebra (Tuple a b)
instance functorTuple :: Functor (Tuple a)
instance invariantTuple :: Invariant (Tuple a)
instance bifunctorTuple :: Bifunctor Tuple
instance applyTuple :: (Semigroup a) => Apply (Tuple a)
instance biapplyTuple :: Biapply Tuple
instance applicativeTuple :: (Monoid a) => Applicative (Tuple a)
instance biapplicativeTuple :: Biapplicative Tuple
instance bindTuple :: (Semigroup a) => Bind (Tuple a)
instance monadTuple :: (Monoid a) => Monad (Tuple a)
instance extendTuple :: Extend (Tuple a)
instance comonadTuple :: Comonad (Tuple a)
instance lazyTuple :: (Lazy a, Lazy b) => Lazy (Tuple a b)
instance foldableTuple :: Foldable (Tuple a)
instance bifoldableTuple :: Bifoldable Tuple
instance traversableTuple :: Traversable (Tuple a)
instance bitraversableTuple :: Bitraversable Tuple
```

#### `fst`

``` purescript
fst :: forall a b. Tuple a b -> a
```

Returns the first component of a tuple.

#### `snd`

``` purescript
snd :: forall a b. Tuple a b -> b
```

Returns the second component of a tuple.

#### `curry`

``` purescript
curry :: forall a b c. (Tuple a b -> c) -> a -> b -> c
```

Turn a function that expects a tuple into a function of two arguments.

#### `uncurry`

``` purescript
uncurry :: forall a b c. (a -> b -> c) -> Tuple a b -> c
```

Turn a function of two arguments into a function that expects a tuple.

#### `swap`

``` purescript
swap :: forall a b. Tuple a b -> Tuple b a
```

Exchange the first and second components of a tuple.

#### `lookup`

``` purescript
lookup :: forall a b f. (Foldable f, Eq a) => a -> f (Tuple a b) -> Maybe b
```

Lookup a value in a data structure of `Tuple`s, generalizing association lists.


## Module Data.Array

Helper functions for working with immutable Javascript arrays.

_Note_: Depending on your use-case, you may prefer to use `Data.List` or
`Data.Sequence` instead, which might give better performance for certain
use cases. This module is useful when integrating with JavaScript libraries
which use arrays, but immutable arrays are not a practical data structure
for many use cases due to their poor asymptotics.

#### `singleton`

``` purescript
singleton :: forall a. a -> Array a
```

#### `range`

``` purescript
range :: Int -> Int -> Array Int
```

Create an array containing a range of integers, including both endpoints.

#### `(..)`

``` purescript
(..) :: Int -> Int -> Array Int
```

_non-associative / precedence 8_

An infix synonym for `range`.

#### `replicate`

``` purescript
replicate :: forall a. Int -> a -> Array a
```

Create an array with repeated instances of a value.

#### `replicateM`

``` purescript
replicateM :: forall m a. (Monad m) => Int -> m a -> m (Array a)
```

Perform a monadic action `n` times collecting all of the results.

#### `some`

``` purescript
some :: forall f a. (Alternative f, Lazy (f (Array a))) => f a -> f (Array a)
```

Attempt a computation multiple times, requiring at least one success.

The `Lazy` constraint is used to generate the result lazily, to ensure
termination.

#### `many`

``` purescript
many :: forall f a. (Alternative f, Lazy (f (Array a))) => f a -> f (Array a)
```

Attempt a computation multiple times, returning as many successful results
as possible (possibly zero).

The `Lazy` constraint is used to generate the result lazily, to ensure
termination.

#### `null`

``` purescript
null :: forall a. Array a -> Boolean
```

#### `length`

``` purescript
length :: forall a. Array a -> Int
```

Get the number of elements in an array.

#### `cons`

``` purescript
cons :: forall a. a -> Array a -> Array a
```

#### `(:)`

``` purescript
(:) :: forall a. a -> Array a -> Array a
```

_right-associative / precedence 6_

An infix alias for `cons`.

Note, the running time of this function is `O(n)`.

#### `snoc`

``` purescript
snoc :: forall a. Array a -> a -> Array a
```

Append an element to the end of an array, creating a new array.

#### `insert`

``` purescript
insert :: forall a. (Ord a) => a -> Array a -> Array a
```

Insert an element into a sorted array.

#### `insertBy`

``` purescript
insertBy :: forall a. (a -> a -> Ordering) -> a -> Array a -> Array a
```

Insert an element into a sorted array, using the specified function to
determine the ordering of elements.

#### `head`

``` purescript
head :: forall a. Array a -> Maybe a
```

#### `last`

``` purescript
last :: forall a. Array a -> Maybe a
```

Get the last element in an array, or `Nothing` if the array is empty

Running time: `O(1)`.

#### `tail`

``` purescript
tail :: forall a. Array a -> Maybe (Array a)
```

Get all but the first element of an array, creating a new array, or `Nothing` if the array is empty

Running time: `O(n)` where `n` is the length of the array

#### `init`

``` purescript
init :: forall a. Array a -> Maybe (Array a)
```

Get all but the last element of an array, creating a new array, or `Nothing` if the array is empty.

Running time: `O(n)` where `n` is the length of the array

#### `uncons`

``` purescript
uncons :: forall a. Array a -> Maybe { head :: a, tail :: Array a }
```

Break an array into its first element and remaining elements.

Using `uncons` provides a way of writing code that would use cons patterns
in Haskell or pre-PureScript 0.7:
``` purescript
f (x : xs) = something
f [] = somethingElse
```
Becomes:
``` purescript
f arr = case uncons arr of
  Just { head: x, tail: xs } -> something
  Nothing -> somethingElse
```

#### `index`

``` purescript
index :: forall a. Array a -> Int -> Maybe a
```

#### `(!!)`

``` purescript
(!!) :: forall a. Array a -> Int -> Maybe a
```

_left-associative / precedence 8_

An infix version of `index`.

#### `elemIndex`

``` purescript
elemIndex :: forall a. (Eq a) => a -> Array a -> Maybe Int
```

Find the index of the first element equal to the specified element.

#### `elemLastIndex`

``` purescript
elemLastIndex :: forall a. (Eq a) => a -> Array a -> Maybe Int
```

Find the index of the last element equal to the specified element.

#### `findIndex`

``` purescript
findIndex :: forall a. (a -> Boolean) -> Array a -> Maybe Int
```

Find the first index for which a predicate holds.

#### `findLastIndex`

``` purescript
findLastIndex :: forall a. (a -> Boolean) -> Array a -> Maybe Int
```

Find the last index for which a predicate holds.

#### `insertAt`

``` purescript
insertAt :: forall a. Int -> a -> Array a -> Maybe (Array a)
```

Insert an element at the specified index, creating a new array, or
returning `Nothing` if the index is out of bounds.

#### `deleteAt`

``` purescript
deleteAt :: forall a. Int -> Array a -> Maybe (Array a)
```

Delete the element at the specified index, creating a new array, or
returning `Nothing` if the index is out of bounds.

#### `updateAt`

``` purescript
updateAt :: forall a. Int -> a -> Array a -> Maybe (Array a)
```

Change the element at the specified index, creating a new array, or
returning `Nothing` if the index is out of bounds.

#### `modifyAt`

``` purescript
modifyAt :: forall a. Int -> (a -> a) -> Array a -> Maybe (Array a)
```

Apply a function to the element at the specified index, creating a new
array, or returning `Nothing` if the index is out of bounds.

#### `alterAt`

``` purescript
alterAt :: forall a. Int -> (a -> Maybe a) -> Array a -> Maybe (Array a)
```

Update or delete the element at the specified index by applying a
function to the current value, returning a new array or `Nothing` if the
index is out-of-bounds.

#### `reverse`

``` purescript
reverse :: forall a. Array a -> Array a
```

#### `concat`

``` purescript
concat :: forall a. Array (Array a) -> Array a
```

Flatten an array of arrays, creating a new array.

#### `concatMap`

``` purescript
concatMap :: forall a b. (a -> Array b) -> Array a -> Array b
```

Apply a function to each element in an array, and flatten the results
into a single, new array.

#### `filter`

``` purescript
filter :: forall a. (a -> Boolean) -> Array a -> Array a
```

Filter an array, keeping the elements which satisfy a predicate function,
creating a new array.

#### `filterM`

``` purescript
filterM :: forall a m. (Monad m) => (a -> m Boolean) -> Array a -> m (Array a)
```

Filter where the predicate returns a monadic `Boolean`.

```purescript
powerSet :: forall a. [a] -> [[a]]
powerSet = filterM (const [true, false])
```

#### `mapMaybe`

``` purescript
mapMaybe :: forall a b. (a -> Maybe b) -> Array a -> Array b
```

Apply a function to each element in an array, keeping only the results
which contain a value, creating a new array.

#### `catMaybes`

``` purescript
catMaybes :: forall a. Array (Maybe a) -> Array a
```

Filter an array of optional values, keeping only the elements which contain
a value, creating a new array.

#### `sort`

``` purescript
sort :: forall a. (Ord a) => Array a -> Array a
```

#### `sortBy`

``` purescript
sortBy :: forall a. (a -> a -> Ordering) -> Array a -> Array a
```

Sort the elements of an array in increasing order, where elements are compared using
the specified partial ordering, creating a new array.

#### `slice`

``` purescript
slice :: forall a. Int -> Int -> Array a -> Array a
```

#### `take`

``` purescript
take :: forall a. Int -> Array a -> Array a
```

Keep only a number of elements from the start of an array, creating a new
array.

#### `takeWhile`

``` purescript
takeWhile :: forall a. (a -> Boolean) -> Array a -> Array a
```

Calculate the longest initial subarray for which all element satisfy the
specified predicate, creating a new array.

#### `drop`

``` purescript
drop :: forall a. Int -> Array a -> Array a
```

Drop a number of elements from the start of an array, creating a new array.

#### `dropWhile`

``` purescript
dropWhile :: forall a. (a -> Boolean) -> Array a -> Array a
```

Remove the longest initial subarray for which all element satisfy the
specified predicate, creating a new array.

#### `span`

``` purescript
span :: forall a. (a -> Boolean) -> Array a -> { init :: Array a, rest :: Array a }
```

Split an array into two parts:

1. the longest initial subarray for which all element satisfy the specified
   predicate
2. the remaining elements

```purescript
span (\n -> n % 2 == 1) [1,3,2,4,5] == { init: [1,3], rest: [2,4,5] }
```

#### `group`

``` purescript
group :: forall a. (Eq a) => Array a -> Array (Array a)
```

Group equal, consecutive elements of an array into arrays.

```purescript
group [1,1,2,2,1] == [[1,1],[2,2],[1]]
```

#### `group'`

``` purescript
group' :: forall a. (Ord a) => Array a -> Array (Array a)
```

Sort and then group the elements of an array into arrays.

```purescript
group' [1,1,2,2,1] == [[1,1,1],[2,2]]
```

#### `groupBy`

``` purescript
groupBy :: forall a. (a -> a -> Boolean) -> Array a -> Array (Array a)
```

Group equal, consecutive elements of an array into arrays, using the
specified equivalence relation to detemine equality.

#### `nub`

``` purescript
nub :: forall a. (Eq a) => Array a -> Array a
```

#### `nubBy`

``` purescript
nubBy :: forall a. (a -> a -> Boolean) -> Array a -> Array a
```

Remove the duplicates from an array, where element equality is determined
by the specified equivalence relation, creating a new array.

#### `union`

``` purescript
union :: forall a. (Eq a) => Array a -> Array a -> Array a
```

Calculate the union of two lists.

Running time: `O(n^2)`

#### `unionBy`

``` purescript
unionBy :: forall a. (a -> a -> Boolean) -> Array a -> Array a -> Array a
```

Calculate the union of two arrays, using the specified function to
determine equality of elements.

#### `delete`

``` purescript
delete :: forall a. (Eq a) => a -> Array a -> Array a
```

Delete the first element of an array which is equal to the specified value,
creating a new array.

#### `deleteBy`

``` purescript
deleteBy :: forall a. (a -> a -> Boolean) -> a -> Array a -> Array a
```

Delete the first element of an array which matches the specified value,
under the equivalence relation provided in the first argument, creating a
new array.

#### `(\\)`

``` purescript
(\\) :: forall a. (Eq a) => Array a -> Array a -> Array a
```

_non-associative / precedence 5_

Delete the first occurrence of each element in the second array from the
first array, creating a new array.

#### `intersect`

``` purescript
intersect :: forall a. (Eq a) => Array a -> Array a -> Array a
```

Calculate the intersection of two arrays, creating a new array.

#### `intersectBy`

``` purescript
intersectBy :: forall a. (a -> a -> Boolean) -> Array a -> Array a -> Array a
```

Calculate the intersection of two arrays, using the specified equivalence
relation to compare elements, creating a new array.

#### `zipWith`

``` purescript
zipWith :: forall a b c. (a -> b -> c) -> Array a -> Array b -> Array c
```

#### `zipWithA`

``` purescript
zipWithA :: forall m a b c. (Applicative m) => (a -> b -> m c) -> Array a -> Array b -> m (Array c)
```

A generalization of `zipWith` which accumulates results in some `Applicative`
functor.

#### `zip`

``` purescript
zip :: forall a b. Array a -> Array b -> Array (Tuple a b)
```

Rakes two lists and returns a list of corresponding pairs.
If one input list is short, excess elements of the longer list are discarded.

#### `unzip`

``` purescript
unzip :: forall a b. Array (Tuple a b) -> Tuple (Array a) (Array b)
```

Transforms a list of pairs into a list of first components and a list of
second components.

#### `foldM`

``` purescript
foldM :: forall m a b. (Monad m) => (a -> b -> m a) -> a -> Array b -> m a
```


## Module Data.Array.Unsafe

Unsafe helper functions for working with immutable arrays.

_Note_: these functions should be used with care, and may result in unspecified
behavior, including runtime exceptions.

#### `unsafeIndex`

``` purescript
unsafeIndex :: forall a. Array a -> Int -> a
```

Find the element of an array at the specified index.

Note: this function can cause unpredictable failure at runtime if the index is out-of-bounds.

#### `head`

``` purescript
head :: forall a. Array a -> a
```

Get the first element of a non-empty array.

Running time: `O(1)`.

#### `tail`

``` purescript
tail :: forall a. Array a -> Array a
```

Get all but the first element of a non-empty array.

Running time: `O(n)`, where `n` is the length of the array.

#### `last`

``` purescript
last :: forall a. Array a -> a
```

Get the last element of a non-empty array.

Running time: `O(1)`.

#### `init`

``` purescript
init :: forall a. Array a -> Array a
```

Get all but the last element of a non-empty array.

Running time: `O(n)`, where `n` is the length of the array.


## Module Data.Foreign.Class

This module defines a type class for reading foreign values.

#### `IsForeign`

``` purescript
class IsForeign a where
  read :: Foreign -> F a
```

A type class instance for this class can be written for a type if it
is possible to attempt to _safely_ coerce a `Foreign` value to that
type.

Instances are provided for standard data structures, and the `F` monad
can be used to construct instances for new data structures.

##### Instances
``` purescript
instance foreignIsForeign :: IsForeign Foreign
instance stringIsForeign :: IsForeign String
instance charIsForeign :: IsForeign Char
instance booleanIsForeign :: IsForeign Boolean
instance numberIsForeign :: IsForeign Number
instance intIsForeign :: IsForeign Int
instance arrayIsForeign :: (IsForeign a) => IsForeign (Array a)
instance nullIsForeign :: (IsForeign a) => IsForeign (Null a)
instance undefinedIsForeign :: (IsForeign a) => IsForeign (Undefined a)
instance nullOrUndefinedIsForeign :: (IsForeign a) => IsForeign (NullOrUndefined a)
```

#### `readJSON`

``` purescript
readJSON :: forall a. (IsForeign a) => String -> F a
```

Attempt to read a data structure from a JSON string

#### `readWith`

``` purescript
readWith :: forall a e. (IsForeign a) => (ForeignError -> e) -> Foreign -> Either e a
```

Attempt to read a foreign value, handling errors using the specified function

#### `readProp`

``` purescript
readProp :: forall a i. (IsForeign a, Index i) => i -> Foreign -> F a
```

Attempt to read a property of a foreign value at the specified index


## Module Data.Tuple.Nested

Utilities for n-tuples: sequences longer than two components built from
nested pairs.

Nested tuples arise naturally in product combinators. You shouldn't
represent data using nested tuples, but if combinators you're working with
create them, utilities in this module will allow to to more easily work
with them, including translating to and from more traditional product types.

```purescript
data Address = Address String City (Maybe Province) Country

exampleAddress1 = makeAddress "221B Baker Street" London Nothing UK
exampleAddress2 = makeAddressT $ "221B Baker Street" /\ London /\ Nothing /\ UK

makeAddressT :: Tuple4 String City (Maybe Province) Country -> Address
makeAddressT = uncurry4 Address

makeAddress :: String -> City -> (Maybe Province) -> Country -> Address
makeAddress = curry4 makeAddressT

tupleAddress :: Address -> Tuple4 String City (Maybe Province) Country
tupleAddress (Address a b c d) = tuple4 a b c d
```

#### `Tuple2`

``` purescript
type Tuple2 a z = Tuple a z
```

#### `Tuple3`

``` purescript
type Tuple3 a b z = Tuple (Tuple2 a b) z
```

#### `Tuple4`

``` purescript
type Tuple4 a b c z = Tuple (Tuple3 a b c) z
```

#### `Tuple5`

``` purescript
type Tuple5 a b c d z = Tuple (Tuple4 a b c d) z
```

#### `Tuple6`

``` purescript
type Tuple6 a b c d e z = Tuple (Tuple5 a b c d e) z
```

#### `Tuple7`

``` purescript
type Tuple7 a b c d e f z = Tuple (Tuple6 a b c d e f) z
```

#### `Tuple8`

``` purescript
type Tuple8 a b c d e f g z = Tuple (Tuple7 a b c d e f g) z
```

#### `Tuple9`

``` purescript
type Tuple9 a b c d e f g h z = Tuple (Tuple8 a b c d e f g h) z
```

#### `Tuple10`

``` purescript
type Tuple10 a b c d e f g h i z = Tuple (Tuple9 a b c d e f g h i) z
```

#### `tuple2`

``` purescript
tuple2 :: forall a b. a -> b -> Tuple2 a b
```

Given 2 values, creates a nested 2-tuple.

#### `tuple3`

``` purescript
tuple3 :: forall a b c. a -> b -> c -> Tuple3 a b c
```

Given 3 values, creates a nested 3-tuple.

#### `tuple4`

``` purescript
tuple4 :: forall a b c d. a -> b -> c -> d -> Tuple4 a b c d
```

Given 4 values, creates a nested 4-tuple.

#### `tuple5`

``` purescript
tuple5 :: forall a b c d e. a -> b -> c -> d -> e -> Tuple5 a b c d e
```

Given 5 values, creates a nested 5-tuple.

#### `tuple6`

``` purescript
tuple6 :: forall a b c d e f. a -> b -> c -> d -> e -> f -> Tuple6 a b c d e f
```

Given 6 values, creates a nested 6-tuple.

#### `tuple7`

``` purescript
tuple7 :: forall a b c d e f g. a -> b -> c -> d -> e -> f -> g -> Tuple7 a b c d e f g
```

Given 7 values, creates a nested 7-tuple.

#### `tuple8`

``` purescript
tuple8 :: forall a b c d e f g h. a -> b -> c -> d -> e -> f -> g -> h -> Tuple8 a b c d e f g h
```

Given 8 values, creates a nested 8-tuple.

#### `tuple9`

``` purescript
tuple9 :: forall a b c d e f g h i. a -> b -> c -> d -> e -> f -> g -> h -> i -> Tuple9 a b c d e f g h i
```

Given 9 values, creates a nested 9-tuple.

#### `tuple10`

``` purescript
tuple10 :: forall a b c d e f g h i j. a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> Tuple10 a b c d e f g h i j
```

Given 10 values, creates a nested 10-tuple.

#### `uncurry2`

``` purescript
uncurry2 :: forall a b z. (a -> b -> z) -> Tuple2 a b -> z
```

Given a function of 2 arguments, return a function that accepts a 2-tuple.

#### `curry2`

``` purescript
curry2 :: forall a b z. (Tuple2 a b -> z) -> a -> b -> z
```

Given a function that accepts a 2-tuple, return a function of 2 arguments.

#### `uncurry3`

``` purescript
uncurry3 :: forall a b c z. (a -> b -> c -> z) -> Tuple3 a b c -> z
```

Given a function of 3 arguments, return a function that accepts a 3-tuple.

#### `curry3`

``` purescript
curry3 :: forall a b c z. (Tuple3 a b c -> z) -> a -> b -> c -> z
```

Given a function that accepts a 3-tuple, return a function of 3 arguments.

#### `uncurry4`

``` purescript
uncurry4 :: forall a b c d z. (a -> b -> c -> d -> z) -> Tuple4 a b c d -> z
```

Given a function of 4 arguments, return a function that accepts a 4-tuple.

#### `curry4`

``` purescript
curry4 :: forall a b c d z. (Tuple4 a b c d -> z) -> a -> b -> c -> d -> z
```

Given a function that accepts a 4-tuple, return a function of 4 arguments.

#### `uncurry5`

``` purescript
uncurry5 :: forall a b c d e z. (a -> b -> c -> d -> e -> z) -> Tuple5 a b c d e -> z
```

Given a function of 5 arguments, return a function that accepts a 5-tuple.

#### `curry5`

``` purescript
curry5 :: forall a b c d e z. (Tuple5 a b c d e -> z) -> a -> b -> c -> d -> e -> z
```

Given a function that accepts a 5-tuple, return a function of 5 arguments.

#### `uncurry6`

``` purescript
uncurry6 :: forall a b c d e f z. (a -> b -> c -> d -> e -> f -> z) -> Tuple6 a b c d e f -> z
```

Given a function of 6 arguments, return a function that accepts a 6-tuple.

#### `curry6`

``` purescript
curry6 :: forall a b c d e f z. (Tuple6 a b c d e f -> z) -> a -> b -> c -> d -> e -> f -> z
```

Given a function that accepts a 6-tuple, return a function of 6 arguments.

#### `uncurry7`

``` purescript
uncurry7 :: forall a b c d e f g z. (a -> b -> c -> d -> e -> f -> g -> z) -> Tuple7 a b c d e f g -> z
```

Given a function of 7 arguments, return a function that accepts a 7-tuple.

#### `curry7`

``` purescript
curry7 :: forall a b c d e f g z. (Tuple7 a b c d e f g -> z) -> a -> b -> c -> d -> e -> f -> g -> z
```

Given a function that accepts a 7-tuple, return a function of 7 arguments.

#### `uncurry8`

``` purescript
uncurry8 :: forall a b c d e f g h z. (a -> b -> c -> d -> e -> f -> g -> h -> z) -> Tuple8 a b c d e f g h -> z
```

Given a function of 8 arguments, return a function that accepts a 8-tuple.

#### `curry8`

``` purescript
curry8 :: forall a b c d e f g h z. (Tuple8 a b c d e f g h -> z) -> a -> b -> c -> d -> e -> f -> g -> h -> z
```

Given a function that accepts a 8-tuple, return a function of 8 arguments.

#### `uncurry9`

``` purescript
uncurry9 :: forall a b c d e f g h i z. (a -> b -> c -> d -> e -> f -> g -> h -> i -> z) -> Tuple9 a b c d e f g h i -> z
```

Given a function of 9 arguments, return a function that accepts a 9-tuple.

#### `curry9`

``` purescript
curry9 :: forall a b c d e f g h i z. (Tuple9 a b c d e f g h i -> z) -> a -> b -> c -> d -> e -> f -> g -> h -> i -> z
```

Given a function that accepts a 9-tuple, return a function of 9 arguments.

#### `uncurry10`

``` purescript
uncurry10 :: forall a b c d e f g h i j z. (a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> z) -> Tuple10 a b c d e f g h i j -> z
```

Given a function of 10 arguments, return a function that accepts a 10-tuple.

#### `curry10`

``` purescript
curry10 :: forall a b c d e f g h i j z. (Tuple10 a b c d e f g h i j -> z) -> a -> b -> c -> d -> e -> f -> g -> h -> i -> j -> z
```

Given a function that accepts a 10-tuple, return a function of 10 arguments.

#### `(/\)`

``` purescript
(/\) :: forall a b. a -> b -> Tuple a b
```

_left-associative / precedence 6_

Shorthand for constructing n-tuples as nested pairs.
`a /\ b /\ c /\ d` becomes `Tuple (Tuple (Tuple a b) c ) d`


## Module Data.Unfoldable

This module provides a type class for _unfoldable functors_, i.e.
functors which support an `unfoldr` operation.

This allows us to unify various operations on arrays, lists,
sequences, etc.

#### `Unfoldable`

``` purescript
class Unfoldable t where
  unfoldr :: forall a b. (b -> Maybe (Tuple a b)) -> b -> t a
```

This class identifies data structures which can be _unfolded_,
generalizing `unfoldr` on arrays.

The generating function `f` in `unfoldr f` in understood as follows:

- If `f b` is `Nothing`, then `unfoldr f b` should be empty.
- If `f b` is `Just (Tuple a b1)`, then `unfoldr f b` should consist of `a`
  appended to the result of `unfoldr f b1`.

##### Instances
``` purescript
instance unfoldableArray :: Unfoldable Array
```

#### `replicate`

``` purescript
replicate :: forall f a. (Unfoldable f) => Int -> a -> f a
```

Replicate a value some natural number of times.
For example:

~~~ purescript
replicate 2 "foo" == ["foo", "foo"] :: Array String
~~~

#### `replicateA`

``` purescript
replicateA :: forall m f a. (Applicative m, Unfoldable f, Traversable f) => Int -> m a -> m (f a)
```

Perform an Applicative action `n` times, and accumulate all the results.

#### `none`

``` purescript
none :: forall f a. (Unfoldable f) => f a
```

The container with no elements - unfolded with zero iterations.
For example:

~~~ purescript
none == [] :: forall a. Array a
~~~

#### `singleton`

``` purescript
singleton :: forall f a. (Unfoldable f) => a -> f a
```

Contain a single value.
For example:

~~~ purescript
singleton "foo" == ["foo"] :: Array String
~~~


## Module Data.Enum

#### `Cardinality`

``` purescript
newtype Cardinality a
  = Cardinality Int
```

#### `runCardinality`

``` purescript
runCardinality :: forall a. Cardinality a -> Int
```

#### `Enum`

``` purescript
class (Bounded a) <= Enum a where
  cardinality :: Cardinality a
  succ :: a -> Maybe a
  pred :: a -> Maybe a
  toEnum :: Int -> Maybe a
  fromEnum :: a -> Int
```

Type class for enumerations. This should not be considered a part of a
numeric hierarchy, ala Haskell. Rather, this is a type class for small,
ordered sum types with statically-determined cardinality and the ability
to easily compute successor and predecessor elements. e.g. `DayOfWeek`, etc.

Laws:

- ```succ bottom >>= succ >>= succ ... succ [cardinality - 1 times] == top```
- ```pred top    >>= pred >>= pred ... pred [cardinality - 1 times] == bottom```
- ```e1 `compare` e2 == fromEnum e1 `compare` fromEnum e2```
- ```forall a > bottom: pred a >>= succ == Just a```
- ```forall a < top:  succ a >>= pred == Just a```
- ```pred >=> succ >=> pred = pred```
- ```succ >=> pred >=> succ = succ```
- ```toEnum (fromEnum a) = Just a```
- ```forall a > bottom: fromEnum <$> pred a = Just (fromEnum a - 1)```
- ```forall a < top:  fromEnum <$> succ a = Just (fromEnum a + 1)```

##### Instances
``` purescript
instance enumChar :: Enum Char
instance enumMaybe :: (Enum a) => Enum (Maybe a)
instance enumBoolean :: Enum Boolean
instance enumTuple :: (Enum a, Enum b) => Enum (Tuple a b)
instance enumEither :: (Enum a, Enum b) => Enum (Either a b)
```

#### `defaultSucc`

``` purescript
defaultSucc :: forall a. (Int -> Maybe a) -> (a -> Int) -> a -> Maybe a
```

```defaultSucc toEnum fromEnum = succ```

#### `defaultPred`

``` purescript
defaultPred :: forall a. (Int -> Maybe a) -> (a -> Int) -> a -> Maybe a
```

```defaultPred toEnum fromEnum = pred```

#### `defaultToEnum`

``` purescript
defaultToEnum :: forall a. (a -> Maybe a) -> a -> Int -> Maybe a
```

Runs in `O(n)` where `n` is `fromEnum a`

```defaultToEnum succ bottom = toEnum```

#### `defaultFromEnum`

``` purescript
defaultFromEnum :: forall a. (a -> Maybe a) -> a -> Int
```

Runs in `O(n)` where `n` is `fromEnum a`

```defaultFromEnum pred = fromEnum```

#### `enumFromTo`

``` purescript
enumFromTo :: forall a. (Enum a) => a -> a -> Array a
```

Property: ```fromEnum a = a', fromEnum b = b' => forall e', a' <= e' <= b': Exists e: toEnum e' = Just e```

Following from the propery of `intFromTo`, we are sure all elements in `intFromTo (fromEnum a) (fromEnum b)` are `Just`s.

#### `enumFromThenTo`

``` purescript
enumFromThenTo :: forall a. (Enum a) => a -> a -> a -> Array a
```

`[a,b..c]`

Correctness for using `fromJust` is the same as for `enumFromTo`.

#### `intFromTo`

``` purescript
intFromTo :: Int -> Int -> Array Int
```

Property: ```forall e in intFromTo a b: a <= e <= b```

#### `intStepFromTo`

``` purescript
intStepFromTo :: Int -> Int -> Int -> Array Int
```

Property: ```forall e in intStepFromTo step a b: a <= e <= b```


## Module Data.Date

#### `JSDate`

``` purescript
data JSDate :: *
```

A native JavaScript `Date` object.

#### `Date`

``` purescript
newtype Date
```

A combined date/time value. `Date`s cannot be constructed directly to
ensure they are not the `Invalid Date` value, and instead must be created
via `fromJSDate`, `fromEpochMilliseconds`, `fromString`, etc. or the `date`
and `dateTime` functions in the `Data.Date.Locale` and `Data.Date.UTC`
modules.

##### Instances
``` purescript
instance eqDate :: Eq Date
instance ordDate :: Ord Date
instance showDate :: Show Date
```

#### `fromJSDate`

``` purescript
fromJSDate :: JSDate -> Maybe Date
```

Attempts to create a `Date` from a `JSDate`. If the `JSDate` is an invalid
date `Nothing` is returned.

#### `toJSDate`

``` purescript
toJSDate :: Date -> JSDate
```

Extracts a `JSDate` from a `Date`.

#### `fromEpochMilliseconds`

``` purescript
fromEpochMilliseconds :: Milliseconds -> Maybe Date
```

Creates a `Date` value from a number of milliseconds elapsed since 1st
January 1970 00:00:00 UTC.

#### `toEpochMilliseconds`

``` purescript
toEpochMilliseconds :: Date -> Milliseconds
```

Gets the number of milliseconds elapsed since 1st January 1970 00:00:00
UTC for a `Date`.

#### `fromString`

``` purescript
fromString :: String -> Maybe Date
```

Attempts to construct a date from a string value using JavaScript’s
[Date.parse() method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date/parse).
`Nothing` is returned if the parse fails or the resulting date is invalid.

#### `fromStringStrict`

``` purescript
fromStringStrict :: String -> Maybe Date
```

Attempts to construct a date from a simplified extended ISO 8601 format
(`YYYY-MM-DDTHH:mm:ss.sssZ`). `Nothing` is returned if the format is not
an exact match or the resulting date is invalid.

#### `Now`

``` purescript
data Now :: !
```

Effect type for when accessing the current date/time.

#### `now`

``` purescript
now :: forall e. Eff (now :: Now | e) Date
```

Gets a `Date` value for the current date/time according to the current
machine’s local time.

#### `nowEpochMilliseconds`

``` purescript
nowEpochMilliseconds :: forall e. Eff (now :: Now | e) Milliseconds
```

Gets the number of milliseconds elapsed milliseconds since 1st January
1970 00:00:00 UTC according to the current machine’s local time

#### `LocaleOffset`

``` purescript
newtype LocaleOffset
  = LocaleOffset Minutes
```

A timezone locale offset, measured in minutes.

#### `timezoneOffset`

``` purescript
timezoneOffset :: Date -> LocaleOffset
```

Get the locale time offset for a `Date`.

#### `Year`

``` purescript
newtype Year
  = Year Int
```

A year date component value.

##### Instances
``` purescript
instance eqYear :: Eq Year
instance ordYear :: Ord Year
instance semiringYear :: Semiring Year
instance ringYear :: Ring Year
instance showYear :: Show Year
```

#### `Month`

``` purescript
data Month
  = January
  | February
  | March
  | April
  | May
  | June
  | July
  | August
  | September
  | October
  | November
  | December
```

A month date component value.

##### Instances
``` purescript
instance eqMonth :: Eq Month
instance ordMonth :: Ord Month
instance boundedMonth :: Bounded Month
instance boundedOrdMonth :: BoundedOrd Month
instance showMonth :: Show Month
instance enumMonth :: Enum Month
```

#### `DayOfMonth`

``` purescript
newtype DayOfMonth
  = DayOfMonth Int
```

A day-of-month date component value.

##### Instances
``` purescript
instance eqDayOfMonth :: Eq DayOfMonth
instance ordDayOfMonth :: Ord DayOfMonth
```

#### `DayOfWeek`

``` purescript
data DayOfWeek
  = Sunday
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
```

A day-of-week date component value.

##### Instances
``` purescript
instance eqDayOfWeek :: Eq DayOfWeek
instance ordDayOfWeek :: Ord DayOfWeek
instance boundedDayOfWeek :: Bounded DayOfWeek
instance boundedOrdDayOfWeek :: BoundedOrd DayOfWeek
instance showDayOfWeek :: Show DayOfWeek
instance enumDayOfWeek :: Enum DayOfWeek
```


## Module Graphics.D3.Util

#### `Magnitude`

``` purescript
class Magnitude n
```

##### Instances
``` purescript
instance numberMagnitude :: Magnitude Number
instance dateMagnitude :: Magnitude JSDate
```

#### `min'`

``` purescript
min' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> m
```

#### `max'`

``` purescript
max' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> m
```

#### `min`

``` purescript
min :: forall m. (Magnitude m) => Array m -> m
```

#### `max`

``` purescript
max :: forall d m. (Magnitude m) => Array m -> m
```

#### `extent`

``` purescript
extent :: forall m. (Magnitude m) => Array m -> Array m
```

#### `extent'`

``` purescript
extent' :: forall d m. (Magnitude m) => (d -> m) -> Array d -> Array m
```


## Module Graphics.D3.Layout.Force

#### `ForceLayout`

``` purescript
data ForceLayout :: *
```

##### Instances
``` purescript
instance forceGraphLayout :: GraphLayout ForceLayout
```

#### `forceLayout`

``` purescript
forceLayout :: D3Eff ForceLayout
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


## Module Data.Date.Locale

#### `Locale`

``` purescript
data Locale :: !
```

The effect of reading the current system locale/timezone.

#### `dateTime`

``` purescript
dateTime :: forall e. Year -> Month -> DayOfMonth -> HourOfDay -> MinuteOfHour -> SecondOfMinute -> MillisecondOfSecond -> Eff (locale :: Locale | e) (Maybe Date)
```

Attempts to create a `Date` from date and time components based on the
current machine’s locale. `Nothing` is returned if the resulting date is
invalid.

#### `date`

``` purescript
date :: forall e. Year -> Month -> DayOfMonth -> Eff (locale :: Locale | e) (Maybe Date)
```

Attempts to create a `Date` from date components based on the current
machine’s locale. `Nothing` is returned if the resulting date is invalid.

#### `year`

``` purescript
year :: forall e. Date -> Eff (locale :: Locale | e) Year
```

Gets the year component for a date based on the current machine’s locale.

#### `month`

``` purescript
month :: forall e. Date -> Eff (locale :: Locale | e) Month
```

Gets the month component for a date based on the current machine’s locale.

#### `dayOfMonth`

``` purescript
dayOfMonth :: forall e. Date -> Eff (locale :: Locale | e) DayOfMonth
```

Gets the day-of-month value for a date based on the current machine’s
locale.

#### `dayOfWeek`

``` purescript
dayOfWeek :: forall e. Date -> Eff (locale :: Locale | e) DayOfWeek
```

Gets the day-of-week value for a date based on the current machine’s
locale.

#### `hourOfDay`

``` purescript
hourOfDay :: forall e. Date -> Eff (locale :: Locale | e) HourOfDay
```

Gets the hour-of-day value for a date based on the current machine’s
locale.

#### `minuteOfHour`

``` purescript
minuteOfHour :: forall e. Date -> Eff (locale :: Locale | e) MinuteOfHour
```

Gets the minute-of-hour value for a date based on the current machine’s
locale.

#### `secondOfMinute`

``` purescript
secondOfMinute :: forall e. Date -> Eff (locale :: Locale | e) SecondOfMinute
```

Get the second-of-minute value for a date based on the current machine’s
locale.

#### `millisecondOfSecond`

``` purescript
millisecondOfSecond :: forall e. Date -> Eff (locale :: Locale | e) MillisecondOfSecond
```

Get the millisecond-of-second value for a date based on the current
machine’s locale.

#### `toLocaleString`

``` purescript
toLocaleString :: forall e. Date -> Eff (locale :: Locale | e) String
```

Format a date as a human-readable string (including the date and the
time), based on the current machine's locale. Example output:
"Fri May 22 2015 19:45:07 GMT+0100 (BST)", although bear in mind that this
can vary significantly across platforms.

#### `toLocaleTimeString`

``` purescript
toLocaleTimeString :: forall e. Date -> Eff (locale :: Locale | e) String
```

Format a time as a human-readable string, based on the current machine's
locale. Example output: "19:45:07", although bear in mind that this
can vary significantly across platforms.

#### `toLocaleDateString`

``` purescript
toLocaleDateString :: forall e. Date -> Eff (locale :: Locale | e) String
```

Format a date as a human-readable string, based on the current machine's
locale. Example output: "Friday, May 22, 2015", although bear in mind that
this can vary significantly across platforms.


## Module Data.Date.UTC

#### `dateTime`

``` purescript
dateTime :: Year -> Month -> DayOfMonth -> HourOfDay -> MinuteOfHour -> SecondOfMinute -> MillisecondOfSecond -> Maybe Date
```

Attempts to create a `Date` from UTC date and time components. `Nothing`
is returned if the resulting date is invalid.

#### `date`

``` purescript
date :: Year -> Month -> DayOfMonth -> Maybe Date
```

Attempts to create a `Date` from UTC date components. `Nothing` is
returned if the resulting date is invalid.

#### `year`

``` purescript
year :: Date -> Year
```

Gets the UTC year component for a date.

#### `month`

``` purescript
month :: Date -> Month
```

Gets the UTC month component for a date.

#### `dayOfMonth`

``` purescript
dayOfMonth :: Date -> DayOfMonth
```

Gets the UTC day-of-month value for a date.

#### `dayOfWeek`

``` purescript
dayOfWeek :: Date -> DayOfWeek
```

Gets the UTC day-of-week value for a date.

#### `hourOfDay`

``` purescript
hourOfDay :: Date -> HourOfDay
```

Gets the UTC hour-of-day value for a date.

#### `minuteOfHour`

``` purescript
minuteOfHour :: Date -> MinuteOfHour
```

Gets the UTC minute-of-hour value for a date.

#### `secondOfMinute`

``` purescript
secondOfMinute :: Date -> SecondOfMinute
```

Get the UTC second-of-minute value for a date.

#### `millisecondOfSecond`

``` purescript
millisecondOfSecond :: Date -> MillisecondOfSecond
```

Get the UTC millisecond-of-second value for a date.


## Module Graphics.D3.Scale

#### `Scale`

``` purescript
class Scale s where
  domain :: forall d r. Array d -> s d r -> D3Eff (s d r)
  range :: forall d r. Array r -> s d r -> D3Eff (s d r)
  copy :: forall d r. s d r -> D3Eff (s d r)
  toFunction :: forall d r. s d r -> D3Eff (d -> r)
```

##### Instances
``` purescript
instance scaleLinear :: Scale LinearScale
instance scalePower :: Scale PowerScale
instance scaleLog :: Scale LogScale
instance scaleQuantize :: Scale QuantizeScale
instance scaleQuantile :: Scale QuantileScale
instance scaleThreshold :: Scale ThresholdScale
instance scaleOrdinal :: Scale OrdinalScale
```

#### `Quantitative`

``` purescript
class Quantitative s where
  invert :: s Number Number -> D3Eff (Number -> Number)
  rangeRound :: Array Number -> s Number Number -> D3Eff (s Number Number)
  interpolate :: forall r. Interpolator r -> s Number r -> D3Eff (s Number r)
  clamp :: forall r. Boolean -> s Number r -> D3Eff (s Number r)
  nice :: forall r. Maybe Number -> s Number r -> D3Eff (s Number r)
  getTicks :: forall r. Maybe Number -> s Number r -> D3Eff (Array Number)
  getTickFormat :: forall r. Number -> Maybe String -> s Number r -> D3Eff (Number -> String)
```

##### Instances
``` purescript
instance quantitativeLinear :: Quantitative LinearScale
instance quantitativePower :: Quantitative PowerScale
instance quantitativeLog :: Quantitative LogScale
```

#### `LinearScale`

``` purescript
data LinearScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleLinear :: Scale LinearScale
instance quantitativeLinear :: Quantitative LinearScale
```

#### `PowerScale`

``` purescript
data PowerScale :: * -> * -> *
```

##### Instances
``` purescript
instance scalePower :: Scale PowerScale
instance quantitativePower :: Quantitative PowerScale
```

#### `LogScale`

``` purescript
data LogScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleLog :: Scale LogScale
instance quantitativeLog :: Quantitative LogScale
```

#### `QuantizeScale`

``` purescript
data QuantizeScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleQuantize :: Scale QuantizeScale
```

#### `QuantileScale`

``` purescript
data QuantileScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleQuantile :: Scale QuantileScale
```

#### `ThresholdScale`

``` purescript
data ThresholdScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleThreshold :: Scale ThresholdScale
```

#### `OrdinalScale`

``` purescript
data OrdinalScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleOrdinal :: Scale OrdinalScale
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

#### `quantizeScale`

``` purescript
quantizeScale :: forall r. D3Eff (QuantizeScale Number r)
```

#### `quantileScale`

``` purescript
quantileScale :: forall r. D3Eff (QuantileScale Number r)
```

#### `thresholdScale`

``` purescript
thresholdScale :: forall r. D3Eff (ThresholdScale Number r)
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


## Module Graphics.D3.Time

#### `TimeScale`

``` purescript
data TimeScale :: * -> * -> *
```

##### Instances
``` purescript
instance scaleTime :: Scale TimeScale
```

#### `timeScale`

``` purescript
timeScale :: forall r. D3Eff (TimeScale JSDate r)
```



