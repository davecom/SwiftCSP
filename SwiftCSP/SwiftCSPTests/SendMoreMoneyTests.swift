//
//  SwiftCSPTests.swift
//  SwiftCSPTests
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa
import XCTest

class SendMoreMoneyConstraint<V, D>: ListConstraint <String, Int> {
    
    override init(variables: [String]) {
        super.init(variables: variables)
    }
    
    override func isSatisfied(assignment: Dictionary<String, Int>) -> Bool {
        // if there are duplicate values then it's not correct
        /*let d = Set<Int>(assignment.values.array)
        if d.count < assignment.count {
            return false
        }*/
        
        // if all variables have been assigned, check if it adds up correctly
        if assignment.count == variables.count {
            if let s = assignment["S"], e = assignment["E"], n = assignment["N"], d = assignment["D"], m = assignment["M"], o = assignment["O"], r = assignment["R"], y = assignment["Y"] {
                let send: Int = s * Int(1000) + e * Int(100) + n * Int(10) + d
                let more: Int = m * Int(1000) + o * Int(100) + r * Int(10) + e
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

class SendMoreMoneyTests: XCTestCase {
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
        domains["M"] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        csp = CSP<String, Int>(variables: variables, domains: domains)
        let smmc = SendMoreMoneyConstraint<String, Int>(variables: variables)
        csp.addConstraint(smmc)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs: CSP<String, Int> = csp {
            if let solution = backtrackingSearch(cs) {
                print(solution)
                
                if let s = solution["S"], e = solution["E"], n = solution["N"], d = solution["D"], m = solution["M"], o = solution["O"], r = solution["R"], y = solution["Y"] {
                    let send: Int = s * Int(1000) + e * Int(100) + n * Int(10) + d
                    let more: Int = m * Int(1000) + o * Int(100) + r * Int(10) + e
                    let money: Int = m * 10000 + o * 1000 + n * 100 + e * 10 + y
                    print("\(send) + \(more) = \(money)")
                }
                
                XCTAssert(true, "Pass")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
