//
//  CircuitBoard.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/24/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa

class CircuitBoard: NSObject {  //get hashable for free and dynamic access
    var height: UInt = 1
    var width: UInt = 1
    var color: NSColor = NSColor.redColor()
    var location: (UInt, UInt)?
    
    //generate the domain as a list of tuples of top left corners
    func generateDomain(boardWidth: UInt, boardHeight: UInt) -> [(UInt, UInt)] {
        var domain: [(UInt, UInt)] = []
        for (var x: UInt = 0; x < (boardWidth - width + 1); x++) {
            for (var y: UInt = (height - 1); y < boardHeight; y++) {
                let temp = (x, y)
                domain.append(temp)
            }
        }
        return domain
    }
}