Functions as Objects
===================

  * Function values *are* treated as objects in Scala.
  * The function type `A => B` is just an abbreviation for the class scala.Function[A,B] which is defined as follows

  ```package scala
     trait Function1[A,B] {
       def apply(x: A): B
     }```

  * __Functions are objects with `apply` methods__
  * There are also traits Function2, Function3, ... for functions which take parameters

Expansion of Function Values
---------------------------

  Take the example of the anonymous function `(x: Int) => x * x`
  This gets expanded to:

  ```{ class AnonFun extends Function1[Int, Int] {
         def apply(x: Int) = x * x
       }
       new AnonFun
     }```

  or using shorer *anonymous class syntax*:

  ```new Function1[Int, Int] {
       def apply(x: Int) = x * x
     }```

Expansion of Function Calls
------------------------

  A function call, such as f(a, b), where f is a value of some class type, is expanded to: `f.apply(a, b)`

  The OO-translation of:
  ```val f = (x: Int) => x * x
     f(7)```

  would be:
  ```val f = new Function1[Int, Int] {
       def apply(x: Int) = x * x
     }
     f.apply(7)```

  _Functions are Objects_

Functions and Methods
---------------------

  A method such as `def f(x: Int): Boolean = ...` is not itself a function value.

  But, if f is used in a place where a Function type is expected it is converted automatically to the function value
    `(x: Int) => f(x)`

  or, expanded:

       new Function1[Int, Boolean] {
         def apply(x: Int) = f(x)
       }

  In the lamba calculus the conversion from method to anonymous function application is called _eta-expansion_.

  Exercise: create a List object using our List class that can easily be invoked like `List(1,2)` to create a list containing 1 and 2

     trait List[T] {
       def isEmpty: Boolean
       def head: T
       def tail: List[T]
     }
     class Cons[T](val head: T, val tail: List[T]) extends List[T] {
       def isEmpty = false
     }
     class Nil[T] extends List[T] {
       def isEmpty: Boolean = true
       def head: Nothing = throw new NoSuchElementException("Nil.head")
       def tail: Nothing = throw new NoSuchElementException("Nil.tail")
     }

     object List {
       // List(1,2) = List.apply(1,2)
       def apply[T](x1: T, x2: T): List[T] = new Cons(x1, new Cons(x2, new Nil))
       def apply[T](x: T_: List[T] = new Cons(x, new Nil)
       def apply[T] = new Nil
     }
