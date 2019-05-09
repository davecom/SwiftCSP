//
//  AustralianMapColoringTest.swift
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

final class MapColoringConstraint: BinaryConstraint <String, String> {
    
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
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "Western Australia", place2: "Northern Territory"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "Western Australia", place2: "South Australia"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "South Australia", place2: "Northern Territory"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "Queensland", place2: "Northern Territory"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "Queensland",
            place2: "South Australia"));
        csp?.addConstraint(constraint:MapColoringConstraint(place1: "Queensland", place2: "New South Wales"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "New South Wales", place2: "South Australia"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "Victoria", place2: "South Australia"));
        csp?.addConstraint(constraint: MapColoringConstraint(place1: "Victoria",place2: "New South Wales"));
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        guard let cs: CSP<String, String> = csp else {
            XCTFail("Fail")
            return
        }

        if let solution = backtrackingSearch(csp: cs, mrv: false, lcv: false) {
            print(solution, terminator: "")
            XCTAssertEqual(solution, ["South Australia": "b", "New South Wales": "g", "Western Australia": "r", "Northern Territory": "g", "Victoria": "r", "Tasmania": "r", "Queensland": "r"], "Pass")
        } else {
            XCTFail("Fail")
        }
    }
    
    static var allTests = [
        ("testSolution", testSolution)
    ]
    
}
