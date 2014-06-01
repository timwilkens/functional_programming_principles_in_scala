#Pairs and Tuples

##Sorting Lists Faster

Implement merge sort

If the list consists of zero or one elements, it is already sorted otherwise:
* separate the list into two sub-lists, each containing around half of the elements
* sort the two sub-lists
* merge the sorted sub-lists into a single sorted list

##First MergeSort Implementation

```scala
def msort(xs: List[Int]): List[Int] = {
  val n - xs.length/2
  if (n == 0) xs
  else {
    def merge(xs: List[Int], ys: List[Int]) = {
      xs match {
        case Nil => ys
        case x :: xs1 => ys match {
          case Nil => xs
          case y :: ys1 =>
            if (x < y) x :: merge(xs1, ys)
            else y :: merge(xs, ys1)
         }
      }
    }
    val (fst, snd) = xs splitAt n
    merge(msort(fst, msort(scd))
}
```

##The SplitAt Function

Returns two sublists
* the elements up to the given index
* the elements from that index

The lists are returned in a *pair*

## Detour: Pair and Tuples

The pair consisting of x and y is written (x, y) in Scala.

Ex: `val pair = ("answer", 42)`

The type of this pair is (String, Int)

This works analogously for tuples with more than two elements

##The Tuple Class

Here, all Tuplen classes are modeled after the following pattern:

```scala
case class Tuple2[T1, T2](_1: +T1, _2: +T2) {
  override def toString = "(" + _1 + "," + _2 + ")"
}
```

The fields of a tuple can be accessed with names _1, _2, ...

We can write `val (label, value) = pair`

or we do

```scala
val label = pair._1
val value = pair._2
```

##Merge function

The previous implementation of merge is a little ugly requiring nested pattern matching.

Rewrite it to use pattern matching over pairs

```scala
def merge(xs: List[Int], ys: List[Int]): List[Int] = (xs, ys) match {
  case(Nil, ys) => ys
  case(xs, Nil) => xs
  case(x :: xs1, y :: ys1) =>
    if (x < y) x :: merge(xs1, ys)
    else y :: merge(xs, ys1)
}
```
