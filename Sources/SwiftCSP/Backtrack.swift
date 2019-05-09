//
//  Backtrack.swift
//  SwiftCSP
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

/// the meat of the backtrack algorithm - a recursive depth first search
/// 
/// - parameter csp: The CSP to operate on.
/// - parameter assignment: Optionally, an already partially completed assignment.
/// - parameter mrv: Should it use the mrv heuristic to try to improve performance (default false)
/// - parameter lcv: SHould it use the lcv heuristic to try to improve performance (default false) NOT IMPLEMENTED YET
/// - parameter mac3: SHould it use the mac3 heuristic to try to improve performance (default false) NOT IMPLEMENTED YET
/// - returns: the assignment (solution), or nil if none can be found
public func backtrackingSearch<V, D>(csp: CSP<V, D>, assignment: Dictionary<V, D> = Dictionary<V, D>(), mrv: Bool = false, lcv: Bool = false, mac3: Bool = false) -> Dictionary<V, D>?
{
    // assignment is complete if it has as many assignments as there are variables
    if assignment.count == csp.variables.count { return assignment }
    
    // get a var to assign
    let variable = selectUnassignedVariable(csp: csp, assignment: assignment, mrv: mrv)
    
    // get the domain of it and try each value in the domain
    for value in orderDomainValues(variable: variable, assignment: assignment, csp: csp, lcv: lcv) {

        // if the value is consistent with the current assignment we continue
        var localAssignment = assignment
        localAssignment[variable] = value
        //println(assignment)
        if isConsistent(variable: variable, value: value, assignment: localAssignment, csp: csp) {
            //println("Found \(variable) with value \(value) and other assignment \(assignment) consistent")
            
            // do inferencing if we have that turned on
            if mac3 {
                /*
                inferences = inference(var, assignment, csp)
                #by design inferences will have assignments already made
                
                if (inferences != False):
                assignment = inferences
                result = backtrack(assignment, csp)
                
                if (result != False) return result; */
            } else {
                if let result = backtrackingSearch(csp: csp, assignment: localAssignment, mrv: mrv, lcv: lcv, mac3: mac3) {
                    return result
                }
            }
        }
        
        //substitution for removing everything
        //assignment = oldAssignment;
    }
    return nil  //no solution
}

/// check if the value assignment is consistent by checking all constraints of the variable
func isConsistent<V, D>(variable: V, value: D, assignment: Dictionary<V, D>, csp: CSP<V,D>) -> Bool {
    for constraint in csp.constraints[variable]! {  //assume there are constraints for every variable
        if !constraint.isSatisfied(assignment: assignment) {
            return false
        }
    }
    return true;
}

/// Return an unassigned variable - we may want to use some logic here to return the
/// minimum-remaining values
func selectUnassignedVariable<V, D>(csp: CSP<V, D>, assignment: Dictionary<V, D>, mrv: Bool) -> V {
    // do we want to use the mrv heuristic
    if (mrv) {
        //get the one with the fewest remaining values
        var minRemainingValues: Int = Int.max
        var minVariable: V = csp.variables.first!
        for variable in csp.variables where assignment[variable] == nil {
            if csp.domains[variable]!.count < minRemainingValues {
                minRemainingValues = csp.domains[variable]!.count
                minVariable = variable
            }
        }
        return minVariable
    } else { //if not just pick the first one that comes up
        for variable in csp.variables where assignment[variable] == nil {
            return variable
        }
    }
    print("No unassigned variables")
    return csp.variables.first! //will crash if csp has no variables
}

/// get the domain variables in a good order
func orderDomainValues<V, D>(variable: V, assignment: Dictionary<V,D>, csp: CSP<V,D>, lcv: Bool) -> [D] {
    guard let domain = csp.domains[variable] else { return [] }
    if lcv {
        var domainValueCounts: [UInt] = [UInt](repeating: 0, count: domain.count)
        for (index, domainValue) in domain.enumerated() {
            for constraint in csp.constraints[variable] ?? [] {
                let constraintVariables = constraint.vars.filter{ $0 != variable }
                for constraintVariable in constraintVariables where assignment[constraintVariable] == nil {
                    for cvDomainValue in csp.domains[constraintVariable] ?? [] {
                        var testAssignment = assignment
                        testAssignment[variable] = domainValue
                        testAssignment[constraintVariable] = cvDomainValue
                        if constraint.isSatisfied(assignment: testAssignment) {
                            domainValueCounts[index] += 1
                        }
                    }
                }
            }
        }
        // use zip to combine the two arrays and sort that based on the first
        let combined = zip(domainValueCounts, domain).sorted {$0.0 > $1.0}
        return combined.map{ $0.1 } // return sorted order based on least constraining value
    } else {
        // return the domain in its original order
        return domain
    }
}
