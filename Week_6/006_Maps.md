#Maps

A map of type `Map[Key, Value]` is a data structure that associates keys of type `Key` with values of type `Value`

```scala
val romanNumerals = Map("I" -> 1, "V" -> 5, "X" -> 10)
val capitalOfCountry = Map("US" -> "Washington", "Switzerland" -> "Bern")
```

##Maps are Functions

Class `Map[Key, Value]` also extends the function type `Key => Value` so maps an be used everywhere functions can

```scala
capitolOfCountry("US") // Washington
```

Trying to use a key that does not exist in a map returns a NoSuchElementException

If we are trying to query a map we can instead do

`capitolOfCountry get "andorra"`

which will return the value, or None if the key does not exist

##The Option Type

The Option type is defined as

```scala
trait Option[+A]
case class Some[+A](value: A) extends Option[A]
object None extends Option[Nothing]
```

The expression map get key returns
* None - if map does not contain the key
* Some(x) - if map associates the given key with the value x

##Decomposing Option

Since options are defined as case classes, they can be decomposed using pattern matching:

```scala
def showCapital(country: String) = capitolOfCountry.get(country) match {
  case Some(capital) => capital
  case None => "missing data"
}
```

##Sorted and GroupBy

Two useful operations of SQL queries in addition to for-expressions are groupBy and orderBy

orderBy on a collection can be expressed by sortWith and sorted

```scala
val fruit = List("apple", "pear", "orange", "pineapple")
fruit sortWith (_.length < _.length)
fruit.sorted
```

groupBy is available on Scala collections. It partitions a collection into a map of collections accordinf to a discriminator function f

```scala
fruit groupBy (_.head) // Map(p -> List(pear, pineapple),
                       //     a -> List(apple),
                       //     o -> List(orange))
```

##Map Example

A polynomial can be seen as a map from exponents to coefficients.

For instance, x^3 - 2x + 5 can be represented with the following map

`Map(0 -> 5, 1 -> -2, 3 -> 1)`

Based on this, let's design a class `Polynom` that represents polynomials as maps.

```scala
object polynomials {

  class Poly(val terms: Map[Int, Double]) {
    def + (other: Poly) = new Poly(terms ++ (other.terms map adjust))
    def adjust(term: (Int, Double): (Int, Double) = {
      val (exp, coeff) = term
      terms get exp match {
        case Some(coeff1) => exp -> (coeff + coeff1)
        case none => exp -> coeff
      }
    }
    override def toString = 
      (for ((exp, coeff) <- terms.toList.sorted.reverse) yield coeff + "x^" + exp) mkString " + "
  }

  val p1 = new Poly(Map(1 -> 2.0, 3 -> 4.0, 5 -> 6.2))
  val p2 = new Poly(Map(0 -> 3.0, 3 -> 7.0))
  p1 + p2
}
```

##Default Values

So far, maps were *partial functions*: Applying a map to a key value in map(key) could lead to an exception, if the key was not stored in the map.

There is an operation `withDefaulValue` that turns a map into a total function

```scala
val cap1 = capitolOfCountry withDefaultValue "<unknown>"
cap1("andorra") //"<unknown>"
```

We can then modify `Poly`

```scala
class Poly(terms0: Map[Int, Double]) {
  val terms = terms0 withDefaultValue 0.0
  def + (other: Poly) = new Poly(terms ++ (other.terms map adjust))
  def adjust(term: (Int, Double)): (Int, Double) = {
    val (exp, coeff) = term
    exp -> (coeff + terms(exp))
  }
```
