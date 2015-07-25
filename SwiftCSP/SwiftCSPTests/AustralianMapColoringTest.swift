//
//  SwiftCSPTests.swift
//  SwiftCSPTests
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa
import XCTest

class MapColoringConstraint<V, D>: BinaryConstraint <String, String> {
    
    init(place1: String, place2: String) {
        super.init(variable1: place1, variable2: place2)
    }
    
    override func isSatisfied(assignment: Dictionary<String, String>) -> Bool {
        // if either variable is not in the assignment then it must be consistent
        // since they still have their domain
        if assignment[variable1] == nil || assignment[variable2] == nil {
                return true
        }
        // check that the color of var1 does not equal var2
        return assignment[variable1] != assignment[variable2]
    }
}

class AustralianMapColoringTest: XCTestCase {
    var csp: CSP<String, String>?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let variables: [String] = ["Western Australia", "Northern Territory",
            "South Australia", "Queensland", "New South Wales", "Victoria", "Tasmania"]
        var domains = Dictionary<String, [String]>()
        for variable in variables {
            domains[variable] = ["r", "g", "b"]
        }
        
        csp = CSP<String, String>(variables: variables, domains: domains)
        csp?.addConstraint(MapColoringConstraint<String,String>(place1: "Western Australia", place2: "Northern Territory"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "Western Australia", place2: "South Australia"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "South Australia", place2: "Northern Territory"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "Queensland", place2: "Northern Territory"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "Queensland",
            place2: "South Australia"));
        csp?.addConstraint(MapColoringConstraint<String, String>(place1: "Queensland", place2: "New South Wales"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "New South Wales", place2: "South Australia"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "Victoria", place2: "South Australia"));
        csp?.addConstraint( MapColoringConstraint<String, String>(place1: "Victoria",place2: "New South Wales"));
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs: CSP<String, String> = csp {
            if let solution = backtrackingSearch(cs, mrv: false) {
                print(solution)
                XCTAssertEqual(solution, ["South Australia": "b", "New South Wales": "g", "Western Australia": "r", "Northern Territory": "g", "Victoria": "r", "Tasmania": "r", "Queensland": "r"], "Pass")
            } else {
                XCTFail("Fail")
            }
        } else {
            XCTFail("Fail")
        }
    }
    
}
