#More Functions on Lists

##List Methods

**Sublists and element access**
* `xs.length` the number of elements of xs
* `xs.last`   the last element in the list, exception if xs is empty (opposite of head)
* `xs.init`   xs minus the last element, exception if empty (opposite of tail)
* `xs take n` the first n elements of xs, or xs if shorter than n
* `xs drop n` the last elements of xs after the first n
* `xs(n)`     the element of xs at index n

##Creating new lists
* `xs ++ ys`  the list consisting of all elements of xs followed by all elements of ys
* `xs.reverse` the list containing all elements of xs in reversed order
* `xs updated (n, x)` xs with the element at index n changed to value x

##Finding elements
* `xs indexOf x` the index of the first element in xs equal to x, or -1 if x is not in xs
* `xs contains x` same as `(xs indexOf x) >= 0`

##Implementation of last

The complexity of head is (small) constant time.

What is the complexity of last?

To find out, write a possible implementation of last

```scala
def last[T](xs: List[T]): T = xs match {
  case List() => throw new Error("last of empty list")
  case List(x) => x
  case y :: ys => last(ys)
}
```

Last takes steps proportional to the length of the list xs (linear time implementation)

##Init as an external function

```scala
def init[T](xs: List[T]): List[T] = xs match {
  case List() => throw new Error("init of empty list")
  case List(x) => List()
  case y :: ys => y :: init(ys)
}
```

##Imlementation of Concatenation

Remember `xs ::: ys` is identical to `ys.:::(xs)`

Try writing it as a stand alone function:

```scala
def concat[T](xs: List[T], ys: List[T]) = xs match {
  case List() => ys
  case z :: zs => z :: concat(zs, ys)
}
```

Complexity corresponds to the length of xs

##Implementation of reverse

```scala
def reverse[T](xs: List[T]): List[T] = xs match {
  case List() => xs
  case y :: ys => reverse(ys) ++ y
}
```

This implementation is quadratic (length of xs for reverse and length of xs for concat). Better way?

##Remove the element at index n

If n is out of bounds, return the list

```scala
def removeAt(n: Int, xs: List[Int]) = (xs take n) ::: (xs drop n + 1) 
```
