//
//  CSP.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

public struct CSP <V: Hashable, D> {
    let variables: [V]
    let domains: [V: [D]]
    var constraints: [V: [Constraint<V>]] = Dictionary<V, [Constraint<V>]>()
    
    init (variables: [V], domains:[V: [D]]) {
        self.variables = variables
        self.domains = domains
        for variable in variables {
            constraints[variable] = [Constraint]()
            if domains[variable] == nil {
                print("Error: Missing domain for variable \(variable).")
            }
        }
    }
    
    public mutating func addConstraint(constraint: Constraint<V>) {
        for variable in constraint.vars {
            if find(variables, variable) == nil {
                print("Error: Could not find variable \(variable) from constraint \(constraint) in CSP.")
            }
            constraints[variable]?.append(constraint)
        }
    }
}