//
//  Constraint.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

public class Constraint<ValueType: Hashable, DomainType> {
    public func isSatisfied(assignment: Dictionary<ValueType, DomainType>) -> Bool {
        return true
    }
    public var vars: [Variable<ValueType, DomainType>] {return []}
}

public class UnaryConstraint<V: Hashable, D> : Constraint <V, D> {
    public let variable: V
    public init(variable: V) {
        self.variable = variable
    }
    public final override var vars: [V] {return [variable]}
}

public class BinaryConstraint<V: Hashable, D> : Constraint <V, D> {
    public let variable1: V
    public let variable2: V
    public init(variable1: V, variable2: V) {
        self.variable1 = variable1
        self.variable2 = variable2
    }
    
    public final override var vars: [V] {return [variable1, variable2]}
}

public class ListConstraint<V: Hashable, D> : Constraint <V, D> {
    public let variables: [V]
    public init(variables: [V]) {
        self.variables = variables
    }
    
    public final override var vars: [V] {return variables}
}