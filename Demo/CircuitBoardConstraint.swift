//
//  CircuitBoardConstraint.swift
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

import Foundation

//A binary constraint that makes sure two Chip variables do not overlap.
class CircuitBoardConstraint: BinaryConstraint<CircuitBoard, (Int, Int)> {
    
    override init(variable1: CircuitBoard, variable2: CircuitBoard) {
        super.init(variable1: variable1, variable2: variable2)
        //println(self.variable1.width)
        //println(self.variable2.width)
    }
    
    override func isSatisfied(assignment: Dictionary<CircuitBoard, (Int, Int)>) -> Bool {
        //if either variable is not in the assignment then it must be consistent
        //since they still have their domain
        if assignment[variable1] == nil || assignment[variable2] == nil {
            return true
        }
        //check that var1 does not overlap var2
        let rect1 = CGRect(x: assignment[variable1]!.0, y: assignment[variable1]!.1, width: variable1.width, height: variable1.height)
        let rect2 = CGRect(x: assignment[variable2]!.0, y: assignment[variable2]!.1, width: variable2.width, height: variable2.height)
        return !rect1.intersects(rect2)
        
    }
}
