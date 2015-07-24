//
//  SwiftCSPTests.swift
//  SwiftCSPTests
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa
import XCTest

class SendMoreMoneyConstraint<V: Hashable>: ListConstraint <V> {
    
    
    override func isSatisfied<V, D>(assignment: Dictionary<V, D>) -> Bool {
        // if there are duplicate values then it's not correct
        let d = Set(assignment.values)
        if d.count < assignment.count {
            return false
        }
        
        // if all variables have been assigned, check if it adds up correctly
        if assignment.count == variables.count {
            let send: Int = assignment["S"]! * 1000 + assignment["E"]! * 100 + assignment["N"]! * 10 + assignment["D"]!
            let more: Int = assignment["M"]! * 1000 + assignment["O"]! * 100 + assignment["R"]! * 10 + assignment["E"]!
            let money: Int = assignment["M"]! * 10000 + assignment["O"]! * 1000 + assignment["N"]! * 100 + assignment["E"]! * 10 + assignment["Y"]!
            if (send + more) == money {
                return true;
            } else {
                return false;
            }
        }
        
        // until we have all of the variables assigned, the assignment is valid
        return true;
    }
}

class SendMoreMoneyTests: XCTestCase {
    var csp: CSP<String, Int>?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let variables = ["S", "E", "N", "D", "M", "O", "R", "Y"]
        var domains = Dictionary<String, [Int]>()
        for variable in variables {
            domains[variable] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        }
        domains["S"] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        domains["M"] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        csp = CSP(variables, domains)
        csp.addConstraint(SendMoreMoneyConstraint(variables))
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs = csp {
            let solution = backtrackingSearch(cs)
            print(solution)
            
            let send: Int = solution["S"]! * 1000 + solution["E"]! * 100 + solution["N"]! * 10 + solution["D"]!
            let more: Int = solution["M"]! * 1000 + solution["O"]! * 100 + solution["R"]! * 10 + solution["E"]!
            let money: Int = solution["M"]! * 10000 + solution["O"]! * 1000 + solution["N"]! * 100 + solution["E"]! * 10 + solution["Y"]!
            print("\(send) + \(more) = \(money)")
            
            XCTAssert(true, "Pass")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
