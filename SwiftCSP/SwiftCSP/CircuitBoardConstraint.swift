//
//  CircuitBoardConstraint.swift
//  SwiftCSP
//
// The SwiftCSP License (MIT)
//
// Copyright (c) 2015 David Kopec
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

import Foundation

//A binary constraint that makes sure two Chip variables do not overlap.
class CircuitBoardConstraint<V, D>: BinaryConstraint<CircuitBoard, (Int, Int)> {
    
    override init(variable1: CircuitBoard, variable2: CircuitBoard) {
        super.init(variable1: variable1, variable2: variable2)
        //println(self.variable1.width)
        //println(self.variable2.width)
    }
    
    override func isSatisfied(assignment: Dictionary<CircuitBoard, (Int, Int)>) -> Bool {
        //if either variable is not in the assignment then it must be consistent
        //since they still have their domain
//        println(assignment)
//        println(variable1.width)
//        println(variable2.width)
//        println(variable1.height)
//        println(variable2.height)
        if assignment[variable1] == nil || assignment[variable2] == nil {
            return true
        }
        //check that var1 does not overlap var2
        let rect1 = CGRect(x: assignment[variable1]!.0, y: assignment[variable1]!.1, width: variable1.width, height: variable1.height)
        let rect2 = CGRect(x: assignment[variable2]!.0, y: assignment[variable2]!.1, width: variable2.width, height: variable2.height)
        return !CGRectIntersectsRect(rect1, rect2)
        
        //got the overlapping rectangle formula from
        //http://codesam.blogspot.com/2011/02/check-if-two-rectangles-intersect.html
        /*let x1: Int = assignment[variable1]!.0
        let y1: Int = assignment[variable1]!.1
        let x2: Int = variable1.width - 1 + x1
        let y2: Int = y1 - Int(variable1.height + 1
        let x3: Int = assignment[variable2]!.0
        let y3: Int = Int(assignment[variable2]!.1)
        let x4: Int = Int(variable2.width) - 1 + x3
        let y4: Int = y3 - Int(variable2.height) + 1
        
        //print x1, y1, self.var1.name
        //print x2, y2, self.var1.name
        //print x3, y3, self.var2.name
        //print x4, y4, self.var2.name
        //print (x1 > x4 or x2 < x3 or y1 < y4 or y2 > y3)
        return (x1 > x4 || x2 < x3 || y1 < y4 || y2 > y3)*/
    }
}