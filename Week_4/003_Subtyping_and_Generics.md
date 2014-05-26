Subtyping and Generics
======================

Polymorphism
------------

Two principle forms
* subtyping
* generics

In this lecture we will look at their interactions in two areas
* bounds
* variance

Type Bounds
-----------

Consider the method assertAllPos which
* takes an IntSet
* returns the IntSet itself if all its elements are positive
* throws an exception otherwise

What is the best type for this method? Maybe this: `def assertAllPost(s: IntSet): IntSet`

Generally this is fine, but is it possible to be more precise.

The problem with this version though, is that it glosses over the details of the function
* Given an empty set, should return an empty set
* Given a non-empty set with all positive numbers, returns that set
* Given a non-empty set with some negatives, throws an exception

Merely describing our function as going from IntSet to IntSet ignores some of this detail

One way to go along this path is to express that it goes from Empty set to Empty set and NonEmpty to NonEmpty

    def assertAllPos[S <: IntSet](r: S): S = ...

"<: IntSet" is an *upper bound* of the type parameter S: it means that S can be instantiated only to types that conform to IntSet
Generally,
* `S <: T` means S is a *subtype* of T
* `S >: T` means S is a *supertype* of T, or T is a *subtype* of S

It is also possible to do something like `[S >: NonEmpty <: IntSet]` which restricts S to any type on the interval between NonEmpty and IntSet

Covariance
----------

Given `NonEmpty <: IntSet` is `List[NonEmpty] <: List[IntSet]`?

Intuitively, this makes sense.

We call types for which this relationship holds __covariant__ because their subtyping relationship varies with the type parameter.

Arrays
------

Look at arrays in Java (and C#)
* an array of T elements is written T[] in Java
* in Scala we use parameterized type syntax Array[T] to refer to the same type

Arrays in Java are covariant so we have `NonEmpty[] <: IntSet[]`

Array Typing Problems
---------------------

Covariant array typing causes problems.
Consider the following Java code

    NonEmpty[] a = new NonEmpty[]{new NonEmpty(1, Empty, Empty)}
    IntSet[] b = a
    b[0] = Empty // Produces ArrayStoreException at runtime
    NonEmpty s = a[0]

In the last line we are assigning an Empty set to a variable type of NonEmpty!

To prevent this, Java stores a type tag with each array and does a runtime check


Question: why use covariance if it creates this hole in the type system?
* allows creation of generalized functions like `sort` which can take arrays of any type
* later versions of Java use generics

The Liskov Substitution Principle
--------------------------------

First stated by Barbara Liskov, this tells us when a type can be a subtype of another:

>If A <: B, then everything one can do with value of type B one should be also be able to do with a value of type A

The actual definition is a bit more formal: Let q(x) be a property provable about objects x of type B. Then q(y) should be 
provable for objects y of type A where A <: B.

Array Example in Scala
---------------------

The problematic array example would be written as follows in Scala:

    val a: Array[NonEmpty] = Array(new NonEmpty(1, Empty, Empty))
    val b: Array[IntSet] = a
    b(0) = Empty
    val s: NonEmpty = a(0)

We would expect to see a type error in Line 2 of the above example since, in Scala, __arrays are not type covariant__
