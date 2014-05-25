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
