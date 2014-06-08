#Putting the Pieces Together

##Task

Phone keys have mnemonics assigned to them

```scla
val mnemonics = Map(
  '2' -> "ABC", '3' -> "DEF", '4' -> "GHI"m '5' -> "JKL",
  '6' -> "MNO", '7' -> "PQRS", '8' -> "TUV", '9' -> "WXYZ")
```

Assume you are given  dictionary of words as a list of words.

Design a method translate such that

`translate(phoneNumber)`

produces all phrases of words that can serve as mnemonics for the phone number

##Background

This example was taken from: *Lutz Prechelt: An Empirical Comparison of Seven Programming Languages*

Tested with Tcl, Python, Perl, Rexx, Java, C++, C

Code size medians:
* 100 lines for scripting languages
* 200-300 lines for the others

```scala
import scala.io.Source

object x {
  val in = Source.fromURL(".....")
  val words = in.getLines.toList filter (word => word forall (chr => chr.isLetter))

  val mnemonics = Map(
    '2' -> "ABC", '3' -> "DEF", '4' -> "GHI"m '5' -> "JKL",
    '6' -> "MNO", '7' -> "PQRS", '8' -> "TUV", '9' -> "WXYZ")

  /** Invert the mnem map to give a map from chars to numbers */
  val charCode: Map[Char, Char] =
    for ((digit, string) <- mnem; letter <- str) yield letter -> digit


  /** Maps a word to the digit string it can represent */
  def wordCode(word: String): String = 
    word.toUpperCase map charCode

  val wordsForNum: Map[String, Seq[String]] =
    words groupBy wordCode withDefaultValue Seq()

  def encode(number: String): Set[List[String]] =
    if (number.isEmpty) Set(List())
    else {
      for {
        split <- 1 to number.length
        word <- wordsForNum(number take split)
        rest <- encode(number drop split)
      } yield word :: rest
    }.toSet

  def translate(number: String): Set[String] = 
    encode(number) map (_ mkString " ")
}
```

Scala's immutable collections are:
* easy to use - few steps to do the job
* concise - one word replaces a whole loop
* safe - type checker is really good at catching erros
* fast - colletion ops are tuned, can be parallelized
* universal - one vocabulary to work on all kinds of collections
