#Reduction of Lists

A common operation on lists is to combine the elements of a list using a given operator

`sum(List(x1, ..., xn))` => 0 + x1 + ... + xn

`product(List(x1, ..., xn))` => 1 * x1 * ... * xn

We can implement this with the usual recursive solution

```scala
def sum(xs: List[Int]): Int = xs match {
  case Nil => 0
  case y :: ys => y + sum(ys)
}
```

##ReduceLeft

This pattern can be abstracted out using the generic method `reduceLeft`

reduceLeft inserts a given binary operator between adjacent elements of a list

```scala
def sum(xs: List[Int]) = (0 :: xs) reduceLeft ((x, y) => x + y)

def product(xs: List[Int]) = (1 :: xs) reduceLeft ((x, y) => x * y)
```

##A Shorter Way to Write Functions

Instead of `((x, y) => x * y)` we can also write `(_ * _)`

Every `_` represents a new parameter, going from left to right.

The parameters are defined at the next outer pair of parentheses

Sum and product can thus be condensed to:

```scala
def sum(xs: List[Int]) = (0 :: xs) reduceLeft (_ + _)
def product(xs: List[Int]) = (1 :: xs) reduceLeft (_ * _)
```

##FoldLeft

The function `reduceLeft` is defined in terms of a more general function `foldLeft`

`foldLeft` is like reduceleft but takes an *accumulator*, z, as an additional parameter, which is returned 
when foldLeft is called on an empty list

```scala
def sum(xs: List[Int]) = (xs foldLeft 0) (_ + _)
def product(xs: List[Int]) = (xs foldLeft 1) (_ * _)
```

##Implementations of ReduceLeft and FoldLeft

These methods can be implemented as follows

```scala
abstract class list[T] { ...
  def reduceLeft(op: (T, T) => T): T = this match {
    case Nil => throw new error("Nil.reduceLeft")
    case x :: xs => (xs foldLeft x)(op)
  }
  def foldLeft[U](z: U)(op: (U, T) => U): U = this match {
    case Nil => z
    x :: xs => (xs foldLeft op(z, x))(op)
  }
}
```

##FoldRight and ReduceRight

Applications of `foldLeft` and `reduceLeft` unfold on trees that lean to the left.

They have two dual functions, `foldRight` and `reduceRight` which produce trees that lean to the right

##Implementation of FoldRight and ReduceRight

```scala
def reduceRight(op: (T, T) => T): T = this match {
  case Nil => throw new Error("Nil.reduceRight")
  case x :: Nil => x
  case x :: xs => op(x, xs.reduceRight(op))
}
def foldRight[U](z: U)(op: (T, U) => U): U = this match {
  case Nil => z
  case x :: xs => op(x, (xs foldRight z)(op))
}
```

##Difference between FoldLeft and FoldRight

For operators that are *associative* and *commutative*, foldLeft and foldRight are equivalent (though they may be different 
with respect to efficiency)

But sometimes, only one of the two operators is appropriate

It is possible to define `concat` in terms of foldRight

```scala
def concat[T](xs: List[T], ys: List[T]): List[T] = 
  (xs foldRight ys) (_ :: _)

This would **not** work with foldLeft because the types do not work (tries to apply cons to elements of type T not List[T])
