//
//  CircuitBoard.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/24/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa

class CircuitBoard: NSObject {  //get hashable for free and dynamic access
    var height: Int = 1
    var width: Int = 1
    var color: NSColor = NSColor.redColor()
    var location: (Int, Int)?
    
    //generate the domain as a list of tuples of bottom left corners
    func generateDomain(boardWidth: Int, boardHeight: Int) -> [(Int, Int)] {
        var domain: [(Int, Int)] = []
        for (var x: Int = 0; x < (boardWidth - width + 1); x++) {
            for (var y: Int = 0; y < (boardHeight - height + 1); y++) {
                let temp = (x, y)
                domain.append(temp)
            }
        }
        return domain
    }
}