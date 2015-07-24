//
//  Variable.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/24/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

public struct Variable<ValueType: Hashable, DomainType>: Equatable {
    public let value: ValueType
    public let domain: [DomainType]
    public var assignment: DomainType?
    public var constraints: [Constraint<ValueType, DomainType>] = [Constraint<ValueType, DomainType>]()
    
    func == (lhs: Variable<ValueType, DomainType>, rhs: Variable<ValueType, DomainType>) -> Bool {
    
    }
}

