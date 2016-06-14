//
//  Backtrack.swift
//  SwiftCSP
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

/// the meat of the backtrack algorithm - a recursive depth first search
/// 
/// - parameter csp: The CSP to operate on.
/// - parameter assignment: Optionally, an already partially completed assignment.
/// - parameter mrv: Should it use the mrv heuristic to try to improve performance (default false)
/// - parameter lcv: SHould it use the lcv heuristic to try to improve performance (default false) NOT IMPLEMENTED YET
/// - parameter mac3: SHould it use the mac3 heuristic to try to improve performance (default false) NOT IMPLEMENTED YET
/// - returns: the assignment (solution), or nil if none can be found
public func backtrackingSearch<V, D>(_ csp: CSP<V, D>, assignment: Dictionary<V, D> = Dictionary<V, D>(), mrv: Bool = false, lcv: Bool = false, mac3: Bool = false) -> Dictionary<V, D>?
{
    // assignment is complete if it has as many assignments as there are variables
    if assignment.count == csp.variables.count { return assignment }
    
    // get a var to assign
    let variable = selectUnassignedVariable(csp, assignment: assignment, mrv: mrv)
    
    // get the domain of it and try each value in the domain
    for value in orderDomainValues(variable, assignment: assignment, csp: csp, lcv: lcv) {

        // if the value is consistent with the current assignment we continue
        var localAssignment = assignment
        localAssignment[variable] = value
        //println(assignment)
        if isConsistent(variable, value: value, assignment: localAssignment, csp: csp) {
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
                if let result = backtrackingSearch(csp, assignment: localAssignment, mrv: mrv, mac3: mac3, lcv: lcv) {
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
func isConsistent<V, D>(_ variable: V, value: D, assignment: Dictionary<V, D>, csp: CSP<V,D>) -> Bool {
    for constraint in csp.constraints[variable]! {  //assume there are constraints for every variable
        if !constraint.isSatisfied(assignment) {
            return false
        }
    }
    return true;
}

/// Return an unassigned variable - we may want to use some logic here to return the
/// minimum-remaining values
func selectUnassignedVariable<V, D>(_ csp: CSP<V, D>, assignment: Dictionary<V, D>, mrv: Bool) -> V {
    // do we want to use the mrv heuristic
    if (mrv) {
        //get the one with the biggest domain
        var maxRemainingValues: Int = 0
        var maxVariable: V = csp.variables.first!
        for variable in csp.variables where assignment[variable] == nil {
            if csp.domains[variable]!.count > maxRemainingValues {
                maxRemainingValues = csp.domains[variable]!.count
                maxVariable = variable
            }
        }
        return maxVariable
    } else { //if not just pick the first one that comes up
        for variable in csp.variables where assignment[variable] == nil {
            return variable
        }
    }
    print("No unassigned variables")
    return csp.variables.first! //will crash if csp has no variables
}

/// get the domain variables in a good order
func orderDomainValues<V, D>(_ variable: V, assignment: Dictionary<V,D>, csp: CSP<V,D>, lcv: Bool) -> [D] {
    return csp.domains[variable]!  //asume there is a domain for every variable
    /*if lcv {  //not implemented yet
        /*// currently works only for binary constraints
        // dictionary that we'll sort by the key - the number of constraints
        Map newOrder = {};
        // go through the constraints of the var for each value
        for (var val in csp.domains[variable]) {
        int constraintCount = 0;
        for (var constraint in csp.constraints[variable]) {
        var variableOfInterest = constraint.variable1;
        if (constraint.variable1 == variable) variableOfInterest = constraint.variable2;
        if (csp.domains[variableOfInterest].contains(val)) constraintCount ++;
        newOrder[val] = constraintCount;
        }
        // sort by the constraint_count and return the lowest ones first
        List valList = [];
        for pair in sorted(new_order.items(), key=itemgetter(1)):
        val_list.append(pair[0])
        return val_list */
    } else {
        // no logic right now just return the domain
        return csp.domains[variable]! //assume there is a domain for every variable
    }*/
}
