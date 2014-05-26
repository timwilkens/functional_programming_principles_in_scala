Lists
=====

The list is a fundamental data structure in functional programming.

A list having `x1,...,xn` as elements is written `List(x1,...,xn)

Examples:
* `val fruit = List("apples", "oranges", "pears")`
* `val nums  = List(1,2,3,4)`
* `val diag3 = List(List(1,0,0), List(0,1,0), List(0,0,1))`
* `val empty = List()`

There are two important differences between lists and arrays
* Lists are **immutable** - the elements of a list cannot be changes.
* Lists are recursive, while arrays are flat.

Every list is composed of elements which have two parts
* A value
* A pointer to the next cell

Each list has a final element which points to `Nil`

The List Type
-------------

Like arrays, lists are **homogeneous**: the elements of a list must all have the same type

The type of a list with elements of type T is written `scala.List[T]` or shorter just `List[T]`

Constructors of Lists
---------------------

All lists are constructed from:
* the empty list Nil
* the construction operation`::` (pronounced cons): `x :: xs` gives a new list with the first element x, followed by the elements of xs

For example:
* `fruit = "apples" :: ("oranges" ::("pears" :: Nil))`
* `nums = 1 :: (2 :: (3 :: (4 :: Nil)))`
* `empty = Nil`

Right Associativity
------------------

Convention: Operators ending in ":" associate to the right

`A :: B :: C --> A :: (B :: C)`

Thus, we can omit the parens

Operators ending in ":" are also different in they are seen as method calls of the *right-hand* operand

`Nil.::(4).::(3).::(2).::(1)`

Operations on Lists
-------------------

All operations on lists can be expressed in terms of the following three operations
* head --> the first element of the list
* tail --> the list composed of all the elements except the first
* isEmpty --> 'true' if the list is empty, 'false' otherwise

These operations are defined as methods of objects of type list
* `fruit.head == "apples"`
* `fruit.tail.head == "oranges"`

List Patterns
-------------

It is also possible to decompose lists with pattern matching
* Nil             --> the `Nil` constant
* p :: ps         --> a pattern that matches a list with a head patching p and a tail matching ps
* List(p1,...,pn) --> same as p1 :: ... :: pn :: Nil

Some examples:
* 1 :: 2 :: xs --> Lists that start with 1 and then 2
* x :: Nil     --> Lists of length 1

The pattern `x :: y :: List(xs, ys) :: zs` matches Lists with a length >= 3.

Sorting Lists
-------------

Suppose we want to sort a list of numbers in ascending order:
* we could sort the list List(7, 3, 9, 2) by sorting the tail List(3, 9, 2) to get List(2, 3, 9)
* we could then insert the head 7 in the right place to get List(2, 3, 7, 9)

This describes *Insertion Sort*

```scala
def isort(xs: List[Int]): List[Int] = xs match {
  case List() => List()
  case y :: ys => insert(y, isort(ys))
}
def insert(x: Int, xs: List[Int]): List[Int] = xs match {
  case List() => List(x)
  case y :: ys => if (x <= y) x :: xs else y :: insert(x, ys)
}
```

What is the worst-case complexity of insertion sort relative to the length of the input list N?
* proportional to N*N
