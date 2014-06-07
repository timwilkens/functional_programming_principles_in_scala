#Queries With For

The for notation is essentially equivalent to the common operations of query languages for databases

Ex: suppose that we have a database books, represented as a list of books

`case class Book(title: String, authors: List[String])`

##A Mini-Database

```scala
val books: List[Book] = List(
  Book(title = "Structure and Interpretation of Computer Programs",
       authors = List("Abelson, Harald", "Sussman, Gerald J.")),
  Book(title = "Introduction to Functional Programming",
       authors = List("Bird, Richard", "Wadler, Phil")))
```

##Some Queuries

Find the title of books whose author's name is "Bird"

```scala
for (b <- books; a <- b.authors if a startsWith "Bird,")
yield b.title
```

Find all the books which have the word "Program" in the title:

```scala
for (b <- books if b.title indexOf "Program" >= 0)
yield b.title
```

Find the names of all authors who have written at least two books present in the database

```scala
for {
  b1 <- books
  b2 <- books
  if b1 != b2
  a1 <- b1.authors
  a2 <- b2.authors
  if a1 == a2
} yield a1
```

How can we avoid duplicating answers? (since we see each pair of books twice)

One solution is to require `if b1.title < a1.title`

But, if we have an author on three books we the author three times!

Solution: remove duplicate authors who are in the results list twice

We achieve this using the `distinct` method.

```scala
{ for {
    b1 <- books
    b2 <- books
    if b1.title < a1.title
    a1 <- b1.authors
    a2 <- b2.authors
    if a1 == a2
  } yield a1
}.distinct
```
