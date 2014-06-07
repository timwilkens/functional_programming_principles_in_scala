#Other Collections

##Other Sequences

We have see that lists are *linear*: Access to the first element is much faster than access to the middle or end

The Scala library also defines an alternative sequence implemenation `Vector`.
* This has more evenly balanced access patterns than `List`.
* Vectors are essentially very very shallow trees
* Vectors start out as arrays of 32 elements. Once too large, they become arrays of 32 pointers to arrays of 32 elements, and so on.
* A depth of 6 can represent 1 billion elements
* This means that Vectors have good random access capabilities
* 32 elements is close to what fits in a modern cache line so computations on each segment are relatively fast
* locality for lists is often much worse than for vectors

So why use Lists at all?
* `head` on a list is a constant time operation
* `head` on a vector may require going down several layers
* taking the `tail` of a list is easy constant time operation
* producing the same `tail` result on a vector is much more complicated
* In general, if you are creating recursive structures and doing operations on them, use List
* If you are using things like `fold`, `map`, and `filter` use a Vector

##Operations on Vectors

Vectors are created analogously to lists:

```scala
val nums = Vector(1, 2, 3, -88)
val people = Vector("Bob", "James", "Peter")
```

They support the same operations as lists, with the exception of `::`

Instead of `x :: xs`, there is:
* `x +: xs` - Create a new vector with leading element x, followed by all the elements of xs.
* `xs :+ x` - Create a new vecotr with trailing element x, preceded by all elements of xs.
* Note that ':' always points to the sequence

Creating a new vector requires updating a single item in each level of the Vector.
* From this we get two copies, re-using many elements, that won't conflict with one another.

##Collection Hierarchy

A common base class of `List` and `Vector` is `Seq`, the class of all *sequences*.

`Seq` itself is a subclass of `Iterable`. 

##Arrays and Strings

Arrays and Strings support the same operations as `Seq` and can be implicitly converted to sequences where needed.
* They cannot be subclasses of Seq because they come from Java

```scala
val xs: Array[Int] = Array(1, 2, 3)
xs map (x => 2 * x)

val ys: String = "Hello, World!"
ys filter (_.isUpper)
```

##Ranges

They represent a sequence of evenly spaced integers.

There are three operators to work on ranges: `to` (inclusive), `until` (exclusive), and `by` (step value)

```scala
val r: Range = 1 until 5
val s: Range = 1 to 5
1 to 10 by 3
6 to 1 by -2
```
Ranges are representated as single objects with three fields: lower bound, upper bound, and step value

##Some more Sequence Operations:

* `xs exists p` - true if there is an element z of xs such that p(x) holds
* `xs forall p` - true if p(x) holds for all elements x of xs
* `xs zip ys`   - a sequence of pairs drawn from corresponding elements of sequence xs and ys
* `xs.unzip`    - splits a sequence of pairs xs into two sequences consisting of the first and second pair elements
* `xs.flatMap f` - applies collection-valued function f to all elements of xs and concatenates the results
* `xs.sum`      _ the sum of all elements of this numeric collection
* `xs.product`  - the product of all elements
* `xs.max`      - the largest element in the collection
* `xs.min`      - the smallest element

##Example: Combinations

To list all combinations of numbers x and y where x is drawn from 1 .. M and y is drawn from 1 .. N:

```scala
(1 to M) flatMap (x => (1 .. N) map (y => (x, y)))
```

##Example: Scalar Product

To compute the scalar product of two vectors:

```scala
def scalarProduct(xs: Vector[Double], ys: Vector[Double]): Double = 
  (xs zip ys).map(xy => xy._1 * xy._2).sum
```

An alternative way to write this is with a *pattern matching function value*.

```scala
def scalarProduct(xs: Vector[Double], ys: Vector[Double]): Double = 
  (xs zip ys).map{ case (x, y) => x * y }.sum
```

##Exercise: Primality Test

A number n is *prime* if the only divisors of n are 1 and n itself.

What is a high-level way to write a test for primality of numbers?

For once, value conciseness over efficiency.

```scala
def isPrime(n: Int): Boolean = (2 until n) forall (d => n % d != 0)
```
