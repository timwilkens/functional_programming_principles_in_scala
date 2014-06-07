#Combinatorial Search Example

##Sets

Sets are another basic abstraction in the Scala collections.

A set is written analogously to a sequence:

```scala
val fruit = Set("apple", "banana", "pear")
val s = (1 to 6).toSet
```

Most operations on sequences are also available on sets:

```scala
s map (_ + 2)
fruit filter (_.startWith == "app")
s.nonEmpty
```

##Sets vs Sequences

The principal differences between sets and sequences are:
* Sets are unordered: the elements of a set do not have a predefined order in which they appear in the set
* Sets do not have duplicate elements
* The fundamental operation on sets is contains: `s contains 5`

##Example: N-Queens

The eight queens problem is to place eight queens on a chesboard so that no queen is threated by another.
* In other words, there can't be two queens in the same row, column, or diagonal
* Chess board normally 8 X 8

We want to develop a solution for any number of queens N, not just 8
* One way to solve the problem is to place a queen on each row
* Once we have placed k -1 queens, we must place the kth queen in a column that's not in check

##Algorithm

We can solve this problem with a recursive algorithm:
* Suppose that we have already generated all the solutions consisting of placing k - 1 queens on a board of size n
* Each solution is represented by a list (of length k - 1) containing the numbers of columns (between 0 and n - 1)
* The column number of the queen in the k - 1th row comes first in the list, and so
* The solution set is thus represented as a set of lists, with one element for each solution
* Now, to place the kth queen, we generate all possible extensions of each solution preceded by a new queen

```scala
object nqueens {
  def queens(n: Int): Set[List[Int]] = {
    def placeQueens(k: Int): Set[List[Int]] = 
      if (k == 0) Set(List())
      else
        for {
          queens <- placeQueens(k - 1)
          col <- 0 until n
          if isSafe(col, queens)
        } yield col :: queens
    placeQueens(n)
  }
}
```

Write a function

`def isSafe(col: Int, queens: List[Int]): Boolean`

which tests if a queen placed in an indicated column `col` is valid.

It is assumed that the new queen is placed in the next availabel row after the other placed queens (in row queens.length)

```scala
def isSafe(col: Int, queens: List[Int]): Boolean = { 
  val row = queens.length
  val queensWithRow = (row - 1 to 0 by -1) zip queens

  queensWithRow forall {
    case (r, c) => col != c && math.abs(col - c) != row - r
  }
}
```

To better visualize the soltion we add a function to display the board

```scala
def show(queens: List[Int]) = {
  val lines = 
    for (col <- queens.reverse)
    yield Vector.fille(queens.length)("* ").updated(col, "X ").mkString
  "\n" + (lines mkString "\n")
}
```
