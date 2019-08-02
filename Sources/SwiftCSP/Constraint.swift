//
//  Constraint.swift
//  SwiftCSP
//
//  Copyright (c) 2015-2019 David Kopec
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


/// The base class of all constraints. It usually makes more sense to override one of the canonical subclasses
/// *UnaryConstraint*, *BinaryConstraint*, and *ListConstraint*. V is the type of the variables, and D is the type of the domains.
open class Constraint <V: Hashable, D> {
    /// All subclasses should override this method. It defines whether a constraint has successfully been satisfied.
    ///
    /// - parameter assignment: Potential domain selections for variables that are part of the constraint.
    /// - returns: Whether the constraint is satisfied.
    open func isSatisfied(assignment: Dictionary<V, D>) -> Bool {
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
