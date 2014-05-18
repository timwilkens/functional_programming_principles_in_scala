abstract class Tree {
  def contains(x: Int): Boolean
  def include(x: Int): Tree
}

object Leaf extends Tree {
  def contains(x: Int) = false
  def include(x: Int): Node = new Node(x, Leaf, Leaf)
  override def toString = "."
}

class Node(root: Int, left: Tree, right: Tree) extends Tree {
  def contains(x: Int) = 
    if (x < root) left contains x
    else if (x > root) right contains x
    else true

  def include(x: Int) =
    if (x < root) new Node(root, left include x, right)
    else if (x > root) new Node(root, left, right include x)
    else this

  override def toString = "{" + left + root + right + "}"
}

def BuildTree(nums: List[Int]): Tree = create(Leaf, nums)

def create(tree: Tree, nums: List[Int]): Tree = 
  if (nums.isEmpty) tree
  else create(tree include nums.head, nums.tail)

val tree = BuildTree((1 to 10).toList)

for (x <- (5 to 15)) if (tree contains x) println("Tree contains " + x)
