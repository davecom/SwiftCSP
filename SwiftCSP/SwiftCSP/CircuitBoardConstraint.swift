//
//  CircuitBoardConstraint.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/25/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Foundation

//A binary constraint that makes sure two Chip variables do not overlap.
class CircuitBoardConstraint<V, D>: BinaryConstraint<CircuitBoard, (UInt, UInt)> {
    
    override init(variable1: CircuitBoard, variable2: CircuitBoard) {
        super.init(variable1: variable1, variable2: variable2)
    }
    
    override func isSatisfied(assignment: Dictionary<CircuitBoard, (UInt, UInt)>) -> Bool {
        //if either variable is not in the assignment then it must be consistent
        //since they still have their domain
        if assignment[variable1] == nil || assignment[variable2] == nil {
            return true
        }
        //check that var1 does not overlap var2
        
        //got the overlapping rectangle formula from
        //http://codesam.blogspot.com/2011/02/check-if-two-rectangles-intersect.html
        let x1 = assignment[variable1]!.0
        let y1 = assignment[variable1]!.1
        let x2 = variable1.width - 1 + x1
        let y2 = y1 - variable1.height + 1
        let x3 = assignment[variable2]!.0
        let y3 = assignment[variable2]!.1
        let x4 = variable2.width - 1 + x3
        let y4 = y3 - variable2.height + 1
        
        //print x1, y1, self.var1.name
        //print x2, y2, self.var1.name
        //print x3, y3, self.var2.name
        //print x4, y4, self.var2.name
        //print (x1 > x4 or x2 < x3 or y1 < y4 or y2 > y3)
        return (x1 > x4 || x2 < x3 || y1 < y4 || y2 > y3)
    }
}