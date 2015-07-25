# SwiftCSP
SwiftCSP is a constraint satisfaction problem solver written in pure Swift (no Cocoa). It utilizes a simple backtracking algorithm with plans for future optimizations. At this stage of development, it's fairly slow but it includes examples of solving actual problems. It runs on both iOS and OS X.

A [constraint satisfaction problem](https://en.wikipedia.org/wiki/Constraint_satisfaction_problem) is a problem composed of *variables* that have possible values (*domains*) and *constraints* on what those values can be. A solver finds a potential solution to that problem by selecting values from the domains of each variable that fit the constraints. For more information you should checkout Chapter 6 of Artificial Intelligence: A Modern Approach (Third Edition) by Norvig and Russell.

## Installation
Use the cocoapod `SwiftCSP` or include the files in the Sources directory (`CSP.swift`, `Constraint.swift`, and `Backtrack.swift`) in your project. SwiftCSP is currently compatible with Swift 1.2 (Xcode 6.4).

## Examples/Unit Tests
The unit tests included with the project are also well known toy problems including:
- [The Australian Map Coloring Problem](https://en.wikipedia.org/wiki/Four_color_theorem)
- [Send + More = Money](https://en.wikipedia.org/wiki/Verbal_arithmetic) Note this currently takes ~100 seconds to execute.
- [Eight Queens Problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle)

Looking at them should give you a good idea about how to use the library. In addition, the program included in the main project is an example of the circuit board layout problem.

## Usage
You will need to create an instance of `CSP` and set its `variables` and `domains` at initialization. You will also need to subclass one of `Constraint`'s canonical subclasses: `UnaryConstraint`, `BinaryConstraint`, or `ListConstraint` and implement the `isSatisfied()` method. Then you will need to add instances of your `Constraint` subclass to the `CSP`. All of these classes make use of generics - specifically you should specify the type of the variables and the type of the domains.

To solve your `CSP` you will call the function `backtrackingSearch()`. If your CSP is of any significant size, you will probably want to do this in an asynchronous block or background thread.

### Example
Once again, I suggest looking at the unit tests, but here's a quick overview of what it's like to setup the eight queens problem:
```
let variables: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]  // create the variables, just Ints in this case
var domains = Dictionary<Int, [Int]>() // create the domain (also of Int type)
for variable in variables {
  domains[variable] = []
  for (var i = variable; i < 64; i += 8) {
    domains[variable]?.append(i)
  }
}
        
csp = CSP<Int, Int>(variables: variables, domains: domains)  // initialize the previousl defined CSP
// Note that we specified through generics that its variables and domain are of type Int
let smmc = EightQueensConstraint<Int, Int>(variables: variables) // create a custom constraint
// note that once again we specified both the variables and domain are of type Int
csp?.addConstraint(smmc) // add the constraint
```

When subclassing a `Constraint` subclass, you will want to specify types for the generics as so:
```
class EightQueensConstraint<V, D>: ListConstraint <Int, Int>
```
In Swift 2 you will be able to exclude the *<V, D>* since it allows non-generic subclasses of generic classes.

## Performance
Performance is currently not great for problems with a medium size domain space. Profiling has shown a large portion of this may be attributable to the performance of Swift's native Dictionary type. Improved heuristics such as LCV and MAC3 are planned (spaces in the source code are left for them and contributions are welcome!) and should improve the situation. Swift 2.0 may also improve things. You can turn on the MRV heuristic (which is already implemented) when calling `backtrackingSearch()` to improve performance in many instances.

## Generics
SwiftCSP makes extensive use of generics. It seems like a lot of unnecessary angle brackets, but Swift 1.2 does not allow a non-generic class to be a subclass of a generic class (Swift 2 does) leading to some unecessary generic constraint subclasses. In the future constraint subclasses will not need to be generic themselves. Due to limitation in Swift generics, `Constraint` is a class instead of a protocol.

## Help Wanted
Contributions that implement heuristics, improve performance in other ways, or simplify the design are more than welcome. Just make sure all of the unit tests still run and the new version maintains the flexibility of having any `Hashable` type as a variable and any type as a `Domain`. Additional unit tests are also welcome.

## Authorship and License
SwiftCSP was written by David Kopec and released under the MIT License (see `LICENSE`). It was originally a port of a Dart library I wrote called [constraineD](https://github.com/davecom/constraineD) which itself was a port of a Python library I wrote many years before that.
