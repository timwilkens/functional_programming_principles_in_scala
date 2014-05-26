Pattern Matching
===============

> The task we are trying to solve is find a general and convenient way to access objects in a extensible class hierarchy.

Attempts so far:
* Classification and access methods: quadratic explosion.
* Type tests and casts: unsafe, low-level.
* Object-oriented decomposition: does not always work, need to touch all classes to add a new method.

Solution 2: Functional Decomposition with Pattern Matching
----------------------------------------------------------

Observation: the sole purpose of test and accessor functions is to *reverse* the construction process:
* Which subclass was used?
* What were the arguments of the constructor

This situation is so common that many functional languages automate it which is called **Pattern Matching**

Case Classes
-----------

A *case class* definition is similar to a normal class definition, except that it is preceded by the modifier case

```scala
trait Expr
case class Number(n: Int) extends Expr
case class Sum(e1: Expr, e2: Expr) extends Expr
```

As before this defines a trait Expr and two concrete subclasses Number and Sum

One benefit of this is that the compiler implicitly defines companion objects with apply methods (factory methods)

```scala
object Number {
  def apply(n: Int) = new Number(n)
}
object Sum {
  def apply(e1: Expr, e2: Expr) = new Sum(e1, e2)
}
```

This lets us create new instances as `Number(1)` instead of `new Number(1)`

Pattern Matching
----------------

*Pattern matching* is a generalization of switch from C/Java to class hierarchies.

It is expressed in Scala using the keyword **match**

```scala
def eval(e: Expr): Int = e match {
  case Number(n) => n
  case Sum(e1, e2) => eval(e1) + eval(2)
}
```

Match Syntax
------------

Rules:
* *match* is followed by a sequence of **cases**, pattern => expression
* each case associates an **expression** expr with a **pattern** pat
* a `MatchError` exception is thrown if no pattern matches the value of the selector

Forms of Patterns
----------------

Patterns are constructed from:
* *constructors*, e.q. Number, Sum
* *variables*, e.g. n, e1, e2
* *wildcard patterns* _
* *constants*, e.g. 1, true

Some important things to note:
* Variables always begin with a lowercase letter
* The same variable name can only appear once in a pattern. Sum(x, x) is not a legal pattern.
* Names of constants begin with a capital letter, with the exceptino of the reserved words null, true, false

Evaluation Match Expressions
----------------------------

An expression of the form

`e match { case p1 => e1 ... case pn => en }`

matches the value of the selector e with the patterns p1,...,pn in the order in which they are written.

The whole match expression is rewritten to the right-hand side of the first case where the pattern matches the selector e.

References to pattern variables are replaced by the corresponding parts in the selector.

What Do Patterns Match?
-----------------------

* A constructor pattern `C(p1,...,pn)` matches all the values of type `C` (or a subtype) that have been constructed with arguments matching the patterns `p1,...,pn`
* A variable pattern `x` matches any value, and *binds* the name of the variable to this value.
* A constant pattern `c` matches values that are equal to `c` (in the sense of ==)

Example
-------

```scala
eval(Sum(Number(1)), Number(2))
```

This gets evaluated and subbed into the method body

```scala
Sum(Number(1), Number(2)) match {
  case Number(n) => n
  case Sum(e1, e2) => eval(e1) + eval(e2)
}
```

We have a case match which becomes

```scala
eval(Number(1)) + eval(Number(2))
```

Then rewrite the first half of this expression

```scala
Number(1) match {
  case Number(n) => n
  case Sum(e1, e2) => eval(e1) + eval(e2)
} + eval(Number(2))
```

Simplified

```scala
1 + eval(Number(2))
```

We can do the same for the other side and get our result: 3

Pattern Matching and Methods
---------------------------

It is also possible to define the evaluation function as a method of the base trait

```scala
trait Expr {
  def eval: Int = this match {
    case Number(n) => n
    case Sum(e1, e2) => e1.eval + e2.eval
  }
}
```

How to choose between using pattern matching or using the OO decomposition
* Are we going to be adding many subclasses?  consider OO decomp
* adding many methods? consider pattern matching

This problem is called the **Expression Problem**

Exercise
--------

Write an implementation of show which turns an expression into a string using pattern matching

```scala
trait Expr
case Class Number(n: Int) extends Expr
case Class Sum(e1: Expr, e2: Expr) extends Expr

object exprs {
  def show(e: Expr): String = e match {
    case Number(x) => x.toString
    case Sum(l, r) => show(l) + " + " + show(r)
  }
}
```
