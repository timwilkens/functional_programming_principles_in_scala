#Higher-Order List Functions

##Recurring Patterns for Computations on Lists

The list operations we have seen so far have shown several recurring patterns
* transforming each element in a list in a certain way
* retrieving a list of all elements satisfying a criterion
* combining the elements of a list using an operator

Functional languages allow programmers to write generic functions that implement patterns such
as these using *higher-order functions*

##Applying a Function to Elements of a List

A common operation is to tranform each element of a list and then return the list of results

For example, to multiply each element of a list by the same factor:

```scala
def scaleList(xs: List[Double], factor: Double): List[Double] = xs match {
  case Nil => xs
  case y :: ys => y * factor :: scaleList(ys, factor)
}
```

##Map

This scheme can be generalized to the method *map* of the List class.

Map can be defined as follows:

```scala
abstract class List[T] { ...
  def map[U](f: T => U): List[U] = this match {
    case Nil => this
    case x :: xs => f(x) :: xs.map(f)
  }
}
```

The actual implementation of map is more complicated because it is tail-recursive,
and also because it works for arbitary collections, not just list.

Using map we can compress scaleList:

```scala
def scaleList(xs: List[Double], factor: Double) =
  xs map (x => x * factor)
```

Exercise: write two versions of the function that squares each element of a list

```scala
def squareList(xs: List[Int]): List[Int] =  xs match {
  case Nil => Nil
  case y :: ys => y * y :: squareList(ys)
}
```

```scala
def squareList(xs: List[Int]): List[Int] =
  xs map (x => x * x)
```

##Filtering

Another common operation on lists is to select all elements that meet a certain condition

``scala
def posElems(xs: List[Int]): List[Int] = xs match {
  case Nil => xs
  case y :: ys => if (y > 0) y :: posElems(ys) else posElems(ys)
}
```

##Filter

This pattern is generalized by the method filter of the List class:

```scala
abstract class List[T] { 
  ...
  def filter(p: T => Boolean): List[T] = this match {
    case Nil => this
    case x :: xs => if (p(x)) x :: xs.filter(p) else xs.filter(p)
  }
}
```

Using filter we can write posElems more concisely

```scala
def posElems(xs: List[Int]): List[Int] = 
  xs filter (x => x > 0)
```

Scala also has the `filterNot` function which returns all elements that do meet your criterion

There is also the `partition` method which returns a pair of lists (List(matches), List(not matches))

The method `takeWhile` gives the elements that match the function starting from element 0 until an element does not match

```scala
val nums = List(1, 2, -3, 5, 4)
nums takeWhile(x => x > 0)  // Returns List(1, 2)
```

The companion to `takeWhile` is `dropWhile` which will return the remainder of the list starting at the element that does not match

`span` will return a pair of Lists which are the results of `takeWhile` and `dropWhile`

##Pack

Exercise: write a function `pack` that will return consecutive duplicates of list elements into sublists

`pack(List("a", "a", "a", "b", "c", "c", "a"))`

should return

`List(List("a", "a", "a"), List("b"), List("c", "c"), List("a"))`

```scala
def pack[T](xs: List[T]): List[List[T]] = xs match {
  case Nil => Nil
  case x :: xs =>
    val (first, rest) = xs span (y => y == x)
    first :: pack(rest)
}
```

##Run-length Encoding

Use the pack function to write a function that produces a pair (Char, Int) representing the number of times a character occurs in a row

```scala
def encode[T](xs: List[T]): List[(T, Int)] =
  pack(xs) map (ys => (ys.head, ys.length))
```
