//
//  EightQueensTest.swift
//  SwiftCSPTests
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

import XCTest
@testable import SwiftCSP

final class EightQueensConstraint: ListConstraint <Int, Int> {
    
    override init(variables: [Int]) {
        super.init(variables: variables)
    }
    
    override func isSatisfied(assignment: Dictionary<Int, Int>) -> Bool {
        // not the most efficient check for attacking each other...
        // better to subtract one from the other and go from there
        for q in assignment.values {
            for i in (q - (q % 8))..<q{ //same file backwards
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in (q + 1)...(q + (8 - (q % 8))) { //same file forwards
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q - 9), through: 0, by: -9) { // diagonal up and back
                guard q % 8 > i % 8 else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q - 7), through: 0, by: -7) { // diagonal up and forward
                guard q % 8 < i % 8 else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q + 7), to: 64, by: 7) { // diagonal down and back
                guard i % 8 < q % 8 else { break }
                if assignment.values.firstIndex(of: i) != nil {
                    return false
                }
            }
            for i in stride(from: (q + 9), to: 64, by: 9) { // diagonal down and forward
                guard q % 8 < i % 8 else { break }
                if assignment.values.firstIndex(of: i) != nil {
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
        if (solution.values.firstIndex(of: i) != nil) {
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
            for i in stride(from: variable, to: 64, by: 8) {
                domains[variable]?.append(i)
            }
        }
        
        csp = CSP<Int, Int>(variables: variables, domains: domains)
        let smmc = EightQueensConstraint(variables: variables)
        csp?.addConstraint(constraint: smmc)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs: CSP<Int, Int> = csp {
            if let solution = backtrackingSearch(csp: cs, mrv: true, lcv: false) {
                print(solution, terminator: "")
                drawQueens(solution: solution)
                XCTAssertTrue(cs.constraints[0]![0].isSatisfied(assignment: solution))
            } else {
                XCTFail("Fail")
            }
        } else {
            XCTFail("Fail")
        }
    }
    
    static var allTests = [
        ("testSolution", testSolution)
    ]
}
