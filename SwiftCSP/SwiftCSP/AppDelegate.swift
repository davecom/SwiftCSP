//
//  AppDelegate.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var layoutView: LayoutView!
    var circuitBoards: [CircuitBoard] = []
    let boardWidth: UInt = 20
    let boardHeight: UInt = 20

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func solve(sender: AnyObject) {
        //create the CSP
        var variables = circuitBoards
        var domains: Dictionary<CircuitBoard, [(UInt, UInt)]>  = Dictionary<CircuitBoard, [(UInt, UInt)]>()
        for variable in variables {
            domains[variable] = variable.generateDomain(boardWidth, boardHeight: boardHeight)
        }
        
        var cb_csp: CSP<CircuitBoard, (UInt, UInt)> = CSP<CircuitBoard, (UInt, UInt)>(variables: variables, domains: domains)
        
        //add constraints
        for var i = 0; i < variables.count; i++ {
            for var j = i + 1; j < variables.count; j++ {
                cb_csp.addConstraint(CircuitBoardConstraint<CircuitBoard, (UInt, UInt)>(variable1: variables[i], variable2: variables[j]))
            }
        }
        
        //run the solution and calculate the time it took
        if let solution = backtrackingSearch(cb_csp, mrv: true) {
            for (variable, location) in solution {
                variable.location = location
            }
            layoutView.circuitBoards = solution.keys.array
            layoutView.needsDisplay = true
        } else {
            let nsa: NSAlert = NSAlert()
            nsa.messageText = "No Solution"
            nsa.informativeText = "Couldn't find a way to layout all circuit boards."
            nsa.beginSheetModalForWindow(window, completionHandler: { (_) -> Void in
                return
            })

        }
    }
}

