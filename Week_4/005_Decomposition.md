Decomposition
============

Suppose you want to write a small interpreter for arithmetic expressions.

To keep it simple, lets restrict ourselves to numbers and additions

Expressions can be represented as a class hierarchy, with a base trait
Expr and two subclasses, Number and Sum.

To treat an expression, its necessary to know the expressions shape and its components

This brings us to the following implementation

```scala
trait Expr {
  def isNumber: Boolean
  def isSum: Boolean
  def numValue: Int
  def leftOp: Expr
  def rightOp: Expr
}
class Number(n: Int) extends Expr {
  def isNumber: Boolean = true
  def isSum: Boolean = false
  def numValue: Int = n
  def leftOp: Expr = throw new Error("Number.leftOp")
  def rightOp: Expr = throw new Error("Number.rightOp")
}
class Sum(e1: Expr, e2: Expr) extends Expr {
  def isNumber: Boolean = false
  def isSum: Boolean = true
  def numValue: Int = throw new Error("Sum.numValue")
  def leftOp: Expr = e1
  def rightOp: Expr = e2
}
```

Evaluation of Expressions
========================

You can write an evaluation function as follows

```scala
def eval(e: Expr): Int = {
  if (e.isNumber) e.numValue
  else if (e.isSum) eval(e.leftOp) + eval(e.rightOp)
  else throw new Error("Unknown expression " + e)
}
```

Problem: writing all of this classification and error handling code quickly becomes tedious

Adding New Forms of Expressions
------------------------------

So, what happens if you want to add new expression forms like

`class Prod(e1: Expr, e2: Expr) extends Expr`

`class Var(x: String) extends Expr`


You need to add methods for classification and access to all classes

In total, adding Prod and Var requires adding 25 methods (isVar, isProd, name)

Adding new subclasses tends to increse the number of methods quadratically

Non-Solution: Type Tests and Type Casts
---------------------------------------

A "hacky" solution could use type tests and type casts.

Scala lets you do these using methods defined in class *Any*:

`def isInstanceOf[T]: Boolean // Checks if object conforms to type T`

`def asInstanceOf[T]: T // Cast object into type T`


These correspond to Javas type tests and casts

`x instanceof T`
`(T) x`


Use of these constructs is discouraged in Scala because there are better alternatives.

The Scala implementations of these are deliberately long and awkward for this reason

Eval with Type Tests and Type Casts
----------------------------------

A formulation of the *eval* method using type tests and casts:

```scala
def eval(e: Expr): Int = 
  if (e.isInstanceOf[Number])
    e.asInstanceOf[Number].numValue
  else if (e.isInstanceOf[Sum])
    eval(e.asInstanceOf[Sum].leftOp) +
    eval(e.asInstanceOf[Sum].rightOp)
  else throw new Error("Unknown Expression " + e)
```

Some thoughts about this implementation
* Pro: no need for classification methods, access methods only for classes where the value is defined
* Con: low-level and potentially unsafe

Solution 1: Object-Oriented Decomposition
-----------------------------------------

Suppose that all you want to do is *evaluate* expressions

You could then define:

```scala
trait Expr {
  def eval: Int
}
class Number(n: Int) extends Expr {
  def eval: Int = n
}
class Sum(n: Int) extends Expr {
  def eval: Int = e1.eval + e2.eval
}
```

But what happens if you want to display expressions now?

You have to define new methods in all the subclasses

In general, adding a new method now requires touching all objects that use our base trait

Limitations of OO Decomposition
-------------------------------

What if you want to simplify expressions using a rule like:

`a * b + a * c --> a * (b + c)`

Problem: This a non-local simplification. It cannot be encapsulated in the method of a single object.

This means we are back to square one. We need to write tests and accessor methods in all the subclasses.

This shows that OO Decomp is good for some things (e.g. the eval method) 
but bad at other things (e.g. non-local simplification)
