//
//  SendMoreMoneyConstraint.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/24/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

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