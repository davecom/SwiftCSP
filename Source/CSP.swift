//
//  CSP.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

public struct CSP <ValueType: Hashable, DomainType> {
    let variables: [Variable<ValueType, DomainType>]
    
    init (variables: [Variable<ValueType, DomainType>]) {
        self.variables = variables
    }
    
    public mutating func addConstraint(constraint: Constraint<ValueType, DomainType>) {
        for variable in constraint.vars {
            if find(variables, variable) == nil {
                print("Error: Could not find variable \(variable) from constraint \(constraint) in CSP.")
            }
            constraints[variable]?.append(constraint)
        }
    }
}