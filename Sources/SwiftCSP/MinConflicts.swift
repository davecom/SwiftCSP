//
//  MinConflicts.swift
//  SwiftCSP
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

/// Use the MinConflicts algorithm to try to resolve the CSP
///
/// - parameter csp: The CSP to operate on.
/// - parameter maxSteps: Maxmimum number of steps to try
/// - parameter assignment: Optionally, an already full assignment, .
/// - returns: the assignment (solution), and any remaining conflicted variables
public func minConflicts<V, D>(csp: CSP<V, D>, maxSteps: Int = 100000, assignment: Dictionary<V, D>?) -> (Dictionary<V, D>, Array<V>)
{
    var current = (assignment != nil) ? assignment! : randomAssignment(csp: csp)
    for _ in 0..<maxSteps {
        let conflicted = conflictedVariables(csp: csp, assignment: current)
        if conflicted.isEmpty { return (current, []) }
        let variable = conflicted.randomElement()!
        let value = minimallyConflictedValue(csp: csp, variable: variable, assignment: current)
        current[variable] = value
    }
    return (current, conflictedVariables(csp: csp, assignment: current))
}

/// First uses the MinConflicts algorithm to try to resolve the CSP.
/// Then, if it's not solved after *maxSteps*, runs a backtracking search to find
/// domain values for the remaining conflicted variables.
///
/// - parameter csp: The CSP to operate on.
/// - parameter maxSteps: Maxmimum number of steps to try for the MinConflicts portion
/// - parameter assignment: Optionally, an already full assignment.
/// - parameter mrv: Should it use the mrv heuristic to try to improve performance (default false)
/// - parameter lcv: SHould it use the lcv heuristic to try to improve performance (default false)
/// - parameter mac3: SHould it use the mac3 heuristic to try to improve performance (default false) NOT IMPLEMENTED YET
/// - returns: the assignment (solution), and any remaining conflicted variables
//public func hybridSearch<V, D>(csp: CSP<V, D>, maxSteps: Int = 100000, assignment: Dictionary<V, D>?, mrv: Bool = false, lcv: Bool = false, mac3: Bool = false) -> Dictionary<V, D>? {
//    let (current, conflicted) = minConflicts(csp: csp, maxSteps: maxSteps, assignment: assignment)
//    if conflicted.isEmpty {
//        return current
//    }
//    // Incomplete assignment, so remove conflicting variables from it
//    let partial = current.filter { !conflicted.contains($0.0) }
//    return backtrackingSearch(csp: csp, assignment: partial, mrv: mrv, lcv: lcv, mac3: mac3)
//}

public func minimallyConflictedValue<V, D>(csp: CSP<V, D>, variable: V, assignment: Dictionary<V, D>) -> D {
    let domain = csp.domains[variable]!
    var minimallyConstrained = domain[0]
    var minimumConflictCount = countConflicts(csp: csp, variable: variable, value: minimallyConstrained, assignment: assignment)
    for domainValue in domain.dropFirst() {
        let conflictCount = countConflicts(csp: csp, variable: variable, value: domainValue, assignment: assignment)
        if conflictCount < minimumConflictCount {
            minimumConflictCount = conflictCount
            minimallyConstrained = domainValue
        }
    }
    return minimallyConstrained
}

public func countConflicts<V, D>(csp: CSP<V, D>, variable: V, value: D, assignment: Dictionary<V, D>) -> Int {
    var current = assignment
    current[variable] = value
    var count = 0
    for constraint in csp.constraints[variable]! {
        if !constraint.isSatisfied(assignment: current) {
            count += 1
        }
    }
    return count
}

public func conflictedVariables<V, D>(csp: CSP<V, D>, assignment: Dictionary<V, D>) -> [V] {
    var conflicted: [V] = []
outer: for variable in csp.variables {
        for constraint in csp.constraints[variable]! {
            if !constraint.isSatisfied(assignment: assignment) {
                conflicted.append(variable)
                continue outer
            }
        }
    }
    return conflicted
}

public func randomAssignment<V, D>(csp: CSP<V, D>) -> Dictionary<V, D>
{
    var assignment = Dictionary<V, D>()
    for variable in csp.variables {
        assignment[variable] = csp.domains[variable]!.randomElement()
    }
    return assignment
}
