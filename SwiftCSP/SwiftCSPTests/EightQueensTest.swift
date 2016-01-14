//
//  EightQueensTest.swift
//  SwiftCSPTests
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

import Cocoa
import XCTest

class EightQueensConstraint: ListConstraint <Int, Int> {
    
    override init(variables: [Int]) {
        super.init(variables: variables)
    }
    
    override func isSatisfied(assignment: Dictionary<Int, Int>) -> Bool {
        // not the most efficient check for attacking each other...
        // better to subtract one from the other and go from there
        for q in assignment.values {
            for i in (q - (q % 8))..<q{ //same file backwards
                if assignment.values.indexOf(i) != nil {
                    return false
                }
            }
            for i in (q + 1)...(q + (8 - (q % 8))) { //same file forwards
                if assignment.values.indexOf(i) != nil {
                    return false
                }
            }
            for i in (q - 9).stride(through: 0, by: -9) { // diagonal up and back
                guard q % 8 > i % 8 else { break }
                if assignment.values.indexOf(i) != nil {
                    return false
                }
            }
            for i in (q - 7).stride(through: 0, by: -7) { // diagonal up and forward
                guard q % 8 < i % 8 else { break }
                if assignment.values.indexOf(i) != nil {
                    return false
                }
            }
            for i in (q + 7).stride(to: 64, by: 7) { // diagonal down and back
                guard i % 8 < q % 8 else { break }
                if assignment.values.indexOf(i) != nil {
                    return false
                }
            }
            for i in (q + 9).stride(to: 64, by: 9) { // diagonal down and forward
                guard q % 8 < i % 8 else { break }
                if assignment.values.indexOf(i) != nil {
                    return false
                }
            }
        }
        
        // until we have all of the variables assigned, the assignment is valid
        return true
    }
}

func drawQueens(solution: Dictionary<Int, Int>) {
    var output = "\n"
    for i in 0..<64 {
        if (solution.values.indexOf(i) != nil) {
            output += "Q"
        } else {
            output += "X"
        }
        if (i % 8 == 7) {
            output += "\n"
        }
    }
    print(output, terminator: "");
}

class EightQueensTest: XCTestCase {
    var csp: CSP<Int, Int>?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let variables: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
        var domains = Dictionary<Int, [Int]>()
        for variable in variables {
            domains[variable] = []
            for i in variable.stride(to: 64, by: 8) {
                domains[variable]?.append(i)
            }
        }
        
        csp = CSP<Int, Int>(variables: variables, domains: domains)
        let smmc = EightQueensConstraint(variables: variables)
        csp?.addConstraint(smmc)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs: CSP<Int, Int> = csp {
            if let solution = backtrackingSearch(cs, mrv: true) {
                print(solution, terminator: "")
                drawQueens(solution)
                XCTAssertEqual(solution, [2: 58, 4: 20, 5: 53, 6: 14, 7: 31, 0: 0, 1: 33, 3: 43], "Pass")
            } else {
                XCTFail("Fail")
            }
        } else {
            XCTFail("Fail")
        }
    }    
}
