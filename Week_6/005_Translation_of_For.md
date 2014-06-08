#Translation of For

##For-Expressions and Higher-Order Functions

The syntax for `for` is closely related to the higher-order functions `map`, `flatMap`, and `filter`.

We can define each one in terms of `for`:

```scala
def mapFun[T, U](xs: list[T], f: T => U): List[U] = 
  for (x <- xs) yield f(x)

def flatMap[T, U](xs: List[T], f: T => Iterable[U]): List[U] = 
  for (x <- xs; y <- f(x)) yield y

def filter[T](xs: List[T], p: T => Boolean(: List[T] = 
  for (x <- xs if p(x)) yield x
```

#Translation of For

In reality, the Scala compiler expresses for-expressions in terms of map, flatMap, and a lazy variant of filter.

Here is the translation scheme used by the compiler (simplified)

A simple for-expression

`for (x <- e1) yield e2`

is translated to 

`e1.map(x => e2)`

Another example

`for (x <- e1 if f; s) yield e2`

where f is a filter and s is a (potentially empty) sequence of generators and filters is translated to

`for (x <- e1.withFilter(x => f); s) yield e2`

The last for-expression variant

`for x <- e1; y <- e1; s) yield e3`

is translated into

`e1.flatMap(x => for (y <- e2; s) yield e3`

##Exercise

Translate

```scala
for (b <- books; a <- b.authors if a startsWith "Bird")
yield b.title
```

into higher-order functions.

```scala
books flatMap(b =>
  b.authors withFilter(a => a startsWith "Bird") map (y => y.title)
```

##Generalization of For

The translation of for is not limited to lists or sequences, or even collections.

It is based solely on the presence of the methods map, flatMap, and withFilter.

This lets you use the for syntax for your own types as well - you must only define map, flatMap, and withFilter for these types.

There are many types for which this is useful: arrays, iterators, databases, XML data, optional values, parsers, etc...

##For and Databases

For example, boks might not be a list, but a database stored on some server.

As long as the client interface to the database defines the methods map, flatMap, and withFilter we can use the for syntax for querying the database.

This is the basis for the Scala data base connection frameworks ScalaQuery and Slick.
