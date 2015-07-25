//
//  LayoutView.swift
//  SwiftCSP
//
//  Created by David Kopec on 7/24/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa

class LayoutView: NSView {
    let boxDimension: Int = 20
    var circuitBoards: [CircuitBoard] = []
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        let width = Int(self.frame.size.width)
        let height = Int(self.frame.size.height)
        
        //draw boards
        for board in circuitBoards {
            if let loc = board.location {
                board.color.set()
                let rect = CGRect(x: Int(loc.0 * (width/boxDimension)), y: Int(loc.1 * (height/boxDimension)), width: Int(board.width * (width/boxDimension)), height: Int(board.height * (height/boxDimension)))
                NSRectFill(rect)
            }
        }
        
        //draw grid
        var bPath:NSBezierPath = NSBezierPath()
        
        for var i: Int = 0; i <= boxDimension; i++ {
            bPath.moveToPoint(NSMakePoint(CGFloat((width/boxDimension) * i), CGFloat(0)))
            bPath.lineToPoint(NSMakePoint(CGFloat((width/boxDimension) * i), CGFloat(height)))
        }
        for var i: Int = 0; i <= boxDimension; i++ {
            bPath.moveToPoint(NSMakePoint(CGFloat(0), CGFloat((height/boxDimension) * i)))
            bPath.lineToPoint(NSMakePoint(CGFloat(width), CGFloat((height/boxDimension) * i)))
        }
        
        NSColor.blackColor().set()
        bPath.stroke()
        
    }
    
}
