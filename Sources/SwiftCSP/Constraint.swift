//
//  Constraint.swift
//  SwiftCSP
//
// The SwiftCSP License (MIT)
//
// Copyright (c) 2015-2019 David Kopec
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.


/// The base class of all constraints. It usually makes more sense to override one of the canonical subclasses
/// *UnaryConstraint*, *BinaryConstraint*, and *ListConstraint*. V is the type of the variables, and D is the type of the domains.
open class Constraint <V: Hashable, D> {
    /// All subclasses should override this method. It defines whether a constraint has successfully been satisfied.
    ///
    /// - parameter assignment: Potential domain selections for variables that are part of the constraint.
    /// - returns: Whether the constraint is satisfied.
    public func isSatisfied(assignment: Dictionary<V, D>) -> Bool {
        return true
    }
    /// The variables that make up the constraint.
    public var vars: [V] {return []}
}

/// A constraint on a single variable.
open class UnaryConstraint<V: Hashable, D> : Constraint <V, D> {
    /// The constrained variable.
    public let variable: V
    
    /// Override this constructor in subclasses.
    public init(variable: V) {
        self.variable = variable
    }
    
    /// A list of that single variable
    public final override var vars: [V] {return [variable]}
}

/// A constraint between two variables.
open class BinaryConstraint<V: Hashable, D> : Constraint <V, D> {
    /// The first variable
    public let variable1: V
    /// The second variable
    public let variable2: V
    
    /// Override this constructor in subclasses
    public init(variable1: V, variable2: V) {
        self.variable1 = variable1
        self.variable2 = variable2
    }
    
    /// A list of the first and second variables
    public final override var vars: [V] {return [variable1, variable2]}
}

/// A constraint between any number of variables
open class ListConstraint<V: Hashable, D> : Constraint <V, D> {
    /// The constrained variables
    public let variables: [V]
    
    /// Override this constructor in subclasses
    public init(variables: [V]) {
        self.variables = variables
    }
    
    /// Same as *variables*
    public final override var vars: [V] {return variables}
}
