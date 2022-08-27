//
//  SudokuTest.swift
//  SwiftCSPTests
//
//  Copyright (c) 2022 David Kopec
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

final class SudokuConstraint: BinaryConstraint <SudokuBoard.GridLocation, UInt8> {
    
    init(place1: SudokuBoard.GridLocation, place2: SudokuBoard.GridLocation) {
        super.init(variable1: place1, variable2: place2)
    }
    
    override func isSatisfied(assignment: Dictionary<SudokuBoard.GridLocation, UInt8>) -> Bool {
        // if either variable is not in the assignment then it must be consistent
        // since they still have their domain
        if assignment[variable1] == nil || assignment[variable2] == nil {
                return true
        }
        // check that the number of var1 does not equal var2
        return assignment[variable1] != assignment[variable2]
    }
}

struct SudokuBoard {
    var grid: [[UInt8]] = Array<Array<UInt8>>(repeating: Array<UInt8>(repeating: 0, count: 9), count: 9)
    
    struct GridLocation: Hashable {
        let row: UInt8
        let col: UInt8
        
        var neighbors: [GridLocation] {
            var ns = Set<GridLocation>()
            // All in the same col
            for r in 0..<9 {
                ns.insert(GridLocation(row: UInt8(r), col: col))
            }
            // All in the same row
            for c in 0..<9 {
                ns.insert(GridLocation(row: row, col: UInt8(c)))
            }
            // All in the same subsection
            for r in 0..<9 {
                for c in 0..<9 {
                    if r / 3 == row / 3 && c / 3 == col / 3 {
                        ns.insert(GridLocation(row: UInt8(r), col: UInt8(c)))
                    }
                }
            }
            // no constraints with yourself
            ns.remove(self)
            return Array<GridLocation>(ns)
        }
    }
    
    init(boardDescription: String) {
        // Parse the board
        for (row, line) in boardDescription.split(whereSeparator: \.isNewline).enumerated() {
            for (col, item) in line.enumerated() {
                let numeral = UInt8(item.wholeNumberValue ?? 0)
                if numeral < 10 { grid[row][col] = numeral }
            }
        }
    }
    
    // Tries to solve the puzzle and returns the solution grid
    func solve() -> [[UInt8]]? {
        var variables = [GridLocation]()
        var domains: [GridLocation: [UInt8]] = [GridLocation: [UInt8]]()
        for r in 0..<9 {
            for c in 0..<9 {
                let gl = GridLocation(row: UInt8(r), col: UInt8(c))
                variables.append(gl)
                if grid[r][c] != 0 {
                    domains[gl] = [grid[r][c]]
                } else { // 1 through 9 removing what cannot be
                    domains[gl] = Array<UInt8>(1...9)
                    // remove any values in the same column
                    for neighbor in gl.neighbors {
                        let nv = grid[Int(neighbor.row)][Int(neighbor.col)]
                        if nv != 0 {
                            domains[gl]?.removeAll(where: { $0 == nv })
                        }
                    }
                }
            }
        }
        var csp = CSP(variables: variables, domains: domains)
        var addedConstraints: [(p1: GridLocation, p2: GridLocation)] = []
        for r in 0..<9 {
            for c in 0..<9 {
                let gl = GridLocation(row: UInt8(r), col: UInt8(c))
                for neighbor in gl.neighbors {
                    // have to make sure to not add the same constraint in both directions
                    if !addedConstraints.contains(where: { $0 == (p1: neighbor, p2: gl)}) {
                        csp.addConstraint(constraint: SudokuConstraint(place1: gl, place2: neighbor))
                        addedConstraints.append((gl, neighbor))
                    }
                }
            }
        }
        
        //if let result = hybridSearch(csp: csp, maxSteps: 1000, assignment: nil) {
        if let result = backtrackingSearch(csp: csp) {
        //let (result, conflicted) = minConflicts(csp: csp, maxSteps: 1000000, assignment: nil)
            var solutionGrid: [[UInt8]] = Array<Array<UInt8>>(repeating: Array<UInt8>(repeating: 0, count: 9), count: 9)
            for (key, value) in result {
                solutionGrid[Int(key.row)][Int(key.col)] = value
            }
        //print("Still Conflicted:")
        //print(conflicted)
            return solutionGrid
        } else {
            return nil
        }
    }
}

func printGrid(_ grid: [[UInt8]]) {
    for (row, line) in grid.enumerated() {
        if row % 3 == 0 && row != 0 {
            print("-----------")
        }
        var rowBuild: String = ""
        for (col, item) in line.enumerated() {
            if col % 3 == 0 && col != 0 { rowBuild += "|" }
            if item == 0 {
                rowBuild += "."
            } else {
                rowBuild += item.description
            }
        }
        print(rowBuild)
    }
}

class SudokuTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEasySolution1() {
        let puzzle = """
        2..1.5..3
        .54...71.
        .1.2.3.8.
        6.28.73.4
        .........
        1.53.98.6
        .2.7.1.6.
        .81...24.
        7..4.2..1
        """
        let sb = SudokuBoard(boardDescription: puzzle)
        if let solutionGrid = sb.solve() {
            printGrid(solutionGrid)
            // just check all the rows have unique values...
            // should put some more checks in here, to make sure other constraints came out right
            for row in solutionGrid {
                let uniqueValues = Set(row)
                XCTAssertEqual(uniqueValues.count, row.count, "Not every item in row is unique.")
            }
        } else {
            XCTFail("Could not find solution to puzzle.")
        }
        
    }
    
    func testMediumSolution1() {
        let puzzle = """
        .8..6....
        ..2...18.
        .7...3...
        .....12..
        .43....1.
        .51.76438
        .2.......
        .38...72.
        ..67.9.5.
        """
        let sb = SudokuBoard(boardDescription: puzzle)
        if let solutionGrid = sb.solve() {
            printGrid(solutionGrid)
            // just check all the rows have unique values...
            // should put some more checks in here, to make sure other constraints came out right
            for row in solutionGrid {
                let uniqueValues = Set(row)
                XCTAssertEqual(uniqueValues.count, row.count, "Not every item in row is unique.")
            }
        } else {
            XCTFail("Could not find solution to puzzle.")
        }
        
    }
    
    func testHardSolution1() {
        let puzzle = """
        ..1.....7
        .9...613.
        ...3....4
        .6..2....
        ........1
        ..97..58.
        ..58..39.
        8....7...
        .......4.
        """
        let sb = SudokuBoard(boardDescription: puzzle)
        if let solutionGrid = sb.solve() {
            printGrid(solutionGrid)
            // just check all the rows have unique values...
            // should put some more checks in here, to make sure other constraints came out right
            for row in solutionGrid {
                let uniqueValues = Set(row)
                XCTAssertEqual(uniqueValues.count, row.count, "Not every item in row is unique.")
            }
        } else {
            XCTFail("Could not find solution to puzzle.")
        }
        
    }
    
    static var allTests = [
        ("testEasySolution1", testEasySolution1),
        ("testMediumSolution1", testMediumSolution1),
        ("testHardSolution1", testHardSolution1),
    ]
    
}
