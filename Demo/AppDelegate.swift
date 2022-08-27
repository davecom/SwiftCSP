//
//  AppDelegate.swift
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

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var layoutView: LayoutView!
    @objc var circuitBoards: [CircuitBoard] = []
    let boardWidth: Int = 20
    let boardHeight: Int = 20

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func solve(_ sender: AnyObject) {
        //create the CSP
        let variables = circuitBoards
        var domains: Dictionary<CircuitBoard, [(Int, Int)]> = Dictionary<CircuitBoard, [(Int, Int)]>()
        for variable in variables {
            domains[variable] = variable.generateDomain(boardWidth: boardWidth, boardHeight: boardHeight)
        }
        
        var cb_csp: CSP<CircuitBoard, (Int, Int)> = CSP<CircuitBoard, (Int, Int)>(variables: variables, domains: domains)
        
        //add constraints
        for i in 0..<variables.count {
            for j in (i+1)..<variables.count {
                let cbconst = CircuitBoardConstraint(variable1: variables[i], variable2: variables[j])
                cb_csp.addConstraint(constraint: cbconst)
                //println(cbconst.variable1.width)
                //println(cbconst.variable2.width)
            }
        }
        
        //run the solution and calculate the time it took
        if let solution = backtrackingSearch(csp: cb_csp, mrv: true) {
            for (variable, location) in solution {
                variable.location = location
            }
            layoutView.circuitBoards = Array(solution.keys)
            layoutView.needsDisplay = true
        } else {
            let nsa: NSAlert = NSAlert()
            nsa.messageText = "No Solution"
            nsa.informativeText = "Couldn't find a way to layout all circuit boards."
            nsa.beginSheetModal(for: window, completionHandler: { (_) -> Void in
                return
            })

        }
    }
}

