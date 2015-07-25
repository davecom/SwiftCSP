//
//  Constraint.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//


/// The base class of all constraints. It usually makes more sense to override one of the canonical subclasses
/// *UnaryConstraint*, *BinaryConstraint*, and *ListConstraint*. V is the type of the variables, and D is the type of the domains.
public class Constraint <V: Hashable, D> {
    /// All subclasses should override this method. It defines whether a constraint has successfully been satisfied.
    ///
    /// :param: assignment Potential domain selections for variables that are part of the constraint.
    /// :returns: Whether the constraint is satisfied.
    public func isSatisfied(assignment: Dictionary<V, D>) -> Bool {
        return true
    }
    /// The variables that make up the constraint.
    public var vars: [V] {return []}
}

/// A constraint on a single variable.
public class UnaryConstraint<V: Hashable, D> : Constraint <V, D> {
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
public class BinaryConstraint<V: Hashable, D> : Constraint <V, D> {
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
public class ListConstraint<V: Hashable, D> : Constraint <V, D> {
    /// The constrained variables
    public let variables: [V]
    
    /// Override this constructor in subclasses
    public init(variables: [V]) {
        self.variables = variables
    }
    
    /// Same as *variables*
    public final override var vars: [V] {return variables}
}