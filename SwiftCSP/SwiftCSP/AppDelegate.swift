//
//  AppDelegate.swift
//  SwiftCSP
//
// The SwiftCSP License (MIT)
//
// Copyright (c) 2015 David Kopec
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

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var layoutView: LayoutView!
    var circuitBoards: [CircuitBoard] = []
    let boardWidth: Int = 20
    let boardHeight: Int = 20

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func solve(sender: AnyObject) {
        //create the CSP
        var variables = circuitBoards
        var domains: Dictionary<CircuitBoard, [(Int, Int)]>  = Dictionary<CircuitBoard, [(Int, Int)]>()
        for variable in variables {
            domains[variable] = variable.generateDomain(boardWidth, boardHeight: boardHeight)
        }
        
        var cb_csp: CSP<CircuitBoard, (Int, Int)> = CSP<CircuitBoard, (Int, Int)>(variables: variables, domains: domains)
        
        //add constraints
        for var i = 0; i < variables.count; i++ {
            for var j = i + 1; j < variables.count; j++ {
                let cbconst = CircuitBoardConstraint<CircuitBoard, (Int, Int)>(variable1: variables[i], variable2: variables[j])
                cb_csp.addConstraint(cbconst)
                //println(cbconst.variable1.width)
                //println(cbconst.variable2.width)
            }
        }
        
        //run the solution and calculate the time it took
        if let solution = backtrackingSearch(cb_csp, mrv: true) {
            for (variable, location) in solution {
                variable.location = location
            }
            layoutView.circuitBoards = Array(solution.keys)
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

