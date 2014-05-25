Objects Everywhere
=================

Pure Object Orientation
----------------------

  Argues that Scala is not only a functional language, but also a *pure* object oriented language
    * a pure object-oriented language is one in which *every* value is an object
    * every action is a method call on an object
    * if the language is based on classes, this means that the type of each value is a class

Standard Classes
----------------

  "Conceptually, types such as Int or Boolean do not receive special treatment in Scala.
   They are like the other classes defined in package Scala."

Pure Booleans
------------

  The Boolean type maps to the JVMs primitive type boolean

  But one *could* define it as a class from first principles:

  ```package idealized.scala
     abstract class Boolean {
       def ifThenElse[T](t: => T, e: => T): T

       def && (x: => Boolean): Boolean = ifThenElse(x, false)
       def || (x: => Boolean): Boolean = ifThenElse(true, x)
       def unary_!: Boolean            = ifThenElse(false, true)

       def == (x: Boolean): Boolean    = ifThenElse(x, x.unary_!)
       def != (x: Boolean): Boolean    = ifThenElse(x.unary_!, x)
       ...
     }```

   In our idealized class instead of writing `if (cond) te else ee` we would write `cond.ifThenElse(te, ee)`

Boolean Constants
----------------

  We would then define our constants true and false that go with Boolean in idealized.scala:

  ```package idealized.scala

     object true extends Boolean {
       def ifThenElse[T](t: => T, e: => T) = t
     }

     object false extends Boolean {
       def ifThenElse[T](t: => T, e: =>T) = e
     }
   }```

  Exercise: provide an implemenetation of the comparison operator < in lass idealized.scala.Boolean
 
  Assume for this that false < true

  ```class Boolean {
       def < (x: Boolean) =
         ifTheElse(false, x)
     }```

The class int
------------

  It is possible to make a specification for Int just as we have for Boolean above

  Exercise: provide an implementation of the abstract class Nat that represents non-negative integers

  ```abstract class Nat {
       def isZero: Boolean
       def predecessor: Nat
       def successor: Nat
       def + (that: Nat): Nat
       def - (that: Nat): Nat
     }```

  Do not use standard numerical classes in this implementation.
  Rather, implement a sub-object and a sub-class:

    ```object Zero extends Nat
       class Succ(n: Nat) extends Nat```

   ```abstract class Nat {
       def isZero: Boolean
       def predecessor: Nat
       def successor: new Succ(this)
       def + (that: Nat): Nat
       def - (that: Nat): Nat
     }

     object Zero extends Nat {
       def isZero = true
       def predecessor = throw new Error("0.predecessor")
       def +(that: Nat) = that
       def -(that: Nat) = if (that.isZero) this else throw new Error("negative number")
     }

     class Succ(n: Nat) extends Nat {
       def isZero = false
       def predecessor = n
       def +(that: Nat) = new Succ(n + that)
       def -(that: Nat) = if (that.isZero) this else n - that.predecessor
     }```

  Called _Peano Numbers_
