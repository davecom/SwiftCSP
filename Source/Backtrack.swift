//
//  Backtrack.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/23/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

/// the meat of the backtrack algorithm - a recursive depth first search
/// Returns the assignment, or nil if none can be found
public func backtrackingSearch<V, D>(csp: CSP<V, D>, assignment: Dictionary<V, D> = Dictionary<V, D>(), mrv: Bool = false, lcv: Bool = false, mac3: Bool = false) -> Dictionary<V, D>?
{
    // assignment is complete if it has as many assignments as there are variables
    if assignment.count == csp.variables.count { return assignment }
    
    // get a var to assign
    let variable = selectUnassignedVariable(csp, assignment, mrv)
    
    // get the domain of it and try each value in the domain
    for value in orderDomainValues(variable, assignment, csp, lcv) {

        // if the value is consistent with the current assignment we continue
        if isConsistent(variable, value, assignment, csp) {
            //println("Found \(variable) with value \(value) and other assignment \(assignment) consistent")
            // assign it since it's consistent
            var localAssignment = assignment
            localAssignment[variable] = value
            
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
                let result = backtrackingSearch(csp, assignment: localAssignment, mrv: mrv, mac3: mac3, lcv: lcv);
                if (result != nil) {
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
    var tempAssignment: Dictionary<V, D> = assignment
    tempAssignment[variable] = value
    for constraint in csp.constraints[variable]! {  //assume there are constraints for every variable
        if !constraint.isSatisfied(tempAssignment) {
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
        //get the one with the biggest domain
        var maxRemainingValues: Int = 0
        var maxVariable: V = csp.variables.first!
        for variable in csp.variables {
            if assignment[variable] == nil {
                if csp.domains[variable]!.count > maxRemainingValues {
                    maxRemainingValues = csp.domains[variable]!.count
                    maxVariable = variable
                }
            }
        }
        return maxVariable
    } else { //if not just pick the first one that comes up
        for variable in csp.variables {
            if assignment[variable] == nil {
                return variable
            }
        }
    }
    println("No unassigned variables")
    return csp.variables.first! //will crash if csp has no variables
}

/// get the domain variables in a good order
func orderDomainValues<V, D>(variable: V, assignment: Dictionary<V,D>, csp: CSP<V,D>, lcv: Bool) -> [D] {
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