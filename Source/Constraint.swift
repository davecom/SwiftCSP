//
//  Constraint.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

public class Constraint <V: Hashable> {
    public func isSatisfied<V, D>(assignment: Dictionary<V, D>) -> Bool {
        return true
    }
    public var vars: [V] {return []}
}

public class UnaryConstraint<V: Hashable> : Constraint <V> {
    public let variable: V
    public init(variable: V) {
        self.variable = variable
    }
    public final override var vars: [V] {return [variable]}
}

public class BinaryConstraint<V: Hashable> : Constraint <V> {
    public let variable1: V
    public let variable2: V
    public init(variable1: V, variable2: V) {
        self.variable1 = variable1
        self.variable2 = variable2
    }
    
    public final override var vars: [V] {return [variable1, variable2]}
}

public class ListConstraint<V: Hashable> : Constraint <V> {
    public let variables: [V]
    public init(variables: [V]) {
        self.variables = variables
    }
    
    public final override var vars: [V] {return variables}
}