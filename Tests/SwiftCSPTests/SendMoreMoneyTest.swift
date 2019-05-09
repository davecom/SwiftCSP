//
//  SendMoreMoneyTest.swift
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
            if let s = assignment["S"], let e = assignment["E"], let n = assignment["N"], let d = assignment["D"], let m = assignment["M"], let o = assignment["O"], let r = assignment["R"], let y = assignment["Y"] {
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
            if let solution = backtrackingSearch(csp: cs, mrv: true, lcv: false) {
                print(solution, terminator: "")
                
                if let s = solution["S"], let e = solution["E"], let n = solution["N"], let d = solution["D"], let m = solution["M"], let o = solution["O"], let r = solution["R"], let y = solution["Y"] {
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
    
    static var allTests = [
        ("testSolution", testSolution)
    ]
}
