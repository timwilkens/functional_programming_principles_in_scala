#Combinatorial Search and For-Expressions

##Handling Nested Sequences

We may extend the usage of higher order functions on sequences to man calcuations which are usually expressed using nested loops.

Ex: Given a positive integer n, find all pairs of positive integers i and j, with 1 <= j < i < n such that i + j is prime.

If n = 7, the pairs are (2,1), (3,2), (4,1), (4,3), (5,2), (6,1), (6,5)

##Algorithm

A natural way to do this is to:
* Generate the sequence of all pairs of integers (i, j) such that 1 <= j < i < n
* Filter the pairs for which i + j is prime

One way to generate the sequence of pairs is to:
* Generate all the integers i between 1 and n (excluded)
* For each integer i, generate the list of pairs (i, 1), ... (i, i - 1)

This can be achieved by combining `until` and `map`:

```scala
(1 until n) map (i =>
  (1 until i) map (j => (i, j)))
```

##Generate Pairs

This code gives us a sequence of sequences (a Vector of Vectors containing two elements each)

We want to combine these to have a single collection of pairs

We can combine all the sub-sequences using `foldRight` with `++`:

```scala
(xss foldRight Seq[Int]())(_ ++ _)
```

Or, we can use the built-in method `flatten`

```scala
(1 until n) map (i =>
  (1 until i) map (j => (i, j))).flatten
```

A useful law: `xs flatMap f = (xs map f).flatten`

So, we can simplify the above expression to 

```scala
(1 until n) flatMap (i =>
  (1 until i) map (j => (i, j)))
```

With just map we get: `Vector(Vector(2,1), Vector(3,1)...)`

With flatMap we get: `((2,1), (3,1), ....)`

We can then filter our collection of pairs using `filter (pair => isPrime(pair._1 + pair._2))`

```scala
(1 until n) flatMap (i =>
  (1 until i) map (j => (i, j))) filter (pair =>
    isPrime(pair._1 + pair._2))
```

There is a general problem with this: it's hard to parse visually/hard to understand.

##For-Expressions

Higher-order functions such as `map`, `flatMap` or `filter` provide powerful constructs for manipulating lists.

But sometimes the level of abstraction required by these functions make the program difficult to understand.

Scala's `for expression` notation can help.

##For-Expression Example

Let `persons` be a list of elements of class Person, with fields `name` and `age`

```scala
case class Person(name: String, age: Int)
```

To obtain the names of persons over 20 years old, you can write:

```scala
for (p <- persons if p.age > 20) yield p.name
```

which is equivalent to:

```scala
persons filter (p => p.age > 20) map (p => p.name)
```

The for-expression is similar to loops in imperative languages, except that it builds a list of the results of all iterations.
* Rather than updating values in an existing collection, the for-expression returns a new sequence

##Syntax of For

A for-expression is of the form

`for (s) yield e`

where s is a sequence of *generators* and *filters*, and e is an expressions whose value is returned by an iteration
* a *generator* is of the form `p <- e`, where p is a pattern and e an expression whose value is a collection
* a *filter* is of the form `if f` where f is a boolean expression
* the sequence must start with a generator
* If there are several generators in the sequence, the last generators vary faster than the first

Instead of `( s )`, braces `{ s }` can also be used, and then the sequence of generators and filters can be written
on multiple lines without requiring semicolons.

##Use of For

Here are two examples which were previously solved with higher-order functions:

```scala
for {
  i <- 1 until n
  j <- 1 until 1
  if isPrime(i + j)
} yield (i, j)
```

This version is MUCH clearer than the other using flatMap

Write a version of scalarProduct using a for-expression

```scala
def scalarProduct(xs: List[Double], ys: List[Double]): Double = 
  (for (x, y) <- (xs zip ys) yield x * y).sum
```

