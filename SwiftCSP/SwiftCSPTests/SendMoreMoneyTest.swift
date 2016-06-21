//
//  SendMoreMoneyTest.swift
//  SwiftCSPTests
//
// The SwiftCSP License (MIT)
//
// Copyright (c) 2015-2016 David Kopec
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

final class SendMoreMoneyConstraint: ListConstraint <String, Int> {
    
    override init(variables: [String]) {
        super.init(variables: variables)
    }
    
    override func isSatisfied(assignment: Dictionary<String, Int>) -> Bool {
        // if there are duplicate values then it's not correct
        let d = Set<Int>(assignment.values)
        if d.count < assignment.count {
            return false
        }
        
        // if all variables have been assigned, check if it adds up correctly
        if assignment.count == variables.count {
            if let s = assignment["S"], e = assignment["E"], n = assignment["N"], d = assignment["D"], m = assignment["M"], o = assignment["O"], r = assignment["R"], y = assignment["Y"] {
                let send: Int = s * 1000 + e * 100 + n * 10 + d
                let more: Int = m * 1000 + o * 100 + r * 10 + e
                let money: Int = m * 10000 + o * 1000 + n * 100 + e * 10 + y
                if (send + more) == money {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false
            }
        }
        
        // until we have all of the variables assigned, the assignment is valid
        return true
    }
}

class SendMoreMoneyTest: XCTestCase {
    var csp: CSP<String, Int>?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let variables: [String] = ["S", "E", "N", "D", "M", "O", "R", "Y"]
        var domains = Dictionary<String, [Int]>()
        for variable in variables {
            domains[variable] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        }
        domains["S"] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        domains["M"] = [1]
        
        csp = CSP<String, Int>(variables: variables, domains: domains)
        let smmc = SendMoreMoneyConstraint(variables: variables)
        csp?.addConstraint(constraint: smmc)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs: CSP<String, Int> = csp {
            if let solution = backtrackingSearch(csp: cs, mrv: true) {
                print(solution, terminator: "")
                
                if let s = solution["S"], e = solution["E"], n = solution["N"], d = solution["D"], m = solution["M"], o = solution["O"], r = solution["R"], y = solution["Y"] {
                    let send: Int = s * 1000 + e * 100 + n * 10 + d
                    let more: Int = m * 1000 + o * 100 + r * 10 + e
                    let money: Int = m * 10000 + o * 1000 + n * 100 + e * 10 + y
                    print("\(send) + \(more) = \(money)", terminator: "")
                    XCTAssertEqual((send + more), money, "Pass")
                } else {
                    XCTFail("Fail")
                }
            } else {
                XCTFail("Fail")
            }
        } else {
            XCTFail("Fail")
        }
    }    
}
