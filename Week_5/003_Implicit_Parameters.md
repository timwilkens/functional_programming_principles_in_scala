#Implicit Parameters

##Making Sort More General

We want to be able to have a generalized msort function that can handle strings, ints, booleans, etc...

Idea: parameterize msort: `def msort[T](xs: List[T]): List[T] = `

Problem: '<' is not defined for arbitrary types

Solution: parameterize merge with the necessary comparison function

##Parameterization of Sort

The most flexible design is to make the function sort polymorphic and to pass the comparison
operation as an additional parameter

```scala
def msort[T](xs: List[T])(lt: (T, T) => Boolean) = {

  merge(msort(fst)(lt), msort(snd)(lt))
}
```

Merge can then be modified as follows:

```scala
def merge(xs: List[T], ts: List[T]) = (xs, ys) match {
  ...
  case (x :: xs1, y :: ys1) =>
    if (lt(x, y)) ...
    else ...
}
```

After this modifications we can invoke our msort routine on Ints:

```scala
val nums = List(9, 3, 6, 1, 0)
msort(nums)((x: Int, y: Int) => x < y)
```

We could invoke the same method on a List of Strings:

```scala
val fruits = List("apple", "pineapple", "orange", "banana")
msort(fruits)((x: String, y: String) => x.compareTo(y) < 0)
```

##Parameterization with Ordered

There is already a class in the standard library that represents orderings: scala.math.Ordering[T]

This provides ways to compare elements of type T. Instead of parameterixing with the lt operation directly
we could parameterize with Ordering instead:

```scala
import math.Ordering

def msort[T](xs: List[T])(ord: Ordering) = 

  def merge(xs: List[T], ys: List[T]) = 
  ...
  if (ord.lt(x, y))

  merge(msort(fst)(ord), msort(snd)(ord))
}
```

The calls to msort then become

```scala
msort(nums)(Ordering.Int)
msort(fruits)(Ordering.String)
```

##Aside: Implicit Parameters

Problem: passing around lt or ord values is cumberson

We can avoid this by making ord an implicit parameter

`def msort[T](xs: List[T])(implicit ord: Ordering) = `

Then calls to msort can avoid having to pass in the ordering parameters

The compiler will figure out which ordering to pass based on the types

##Rules for Implicit Parameters

Say a function takes an implicit parameter of type T

The compuler will search for an implicit definition that
* is marked *implicit*
* has a type compatible with T
* is visible at the point of the function call, or is defined in a companion object

If there is a single definition, it will be taken as actual argument for the implicit parameter
