//
//  LayoutView.swift
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

class LayoutView: NSView {
    let boxDimension: Int = 20
    var circuitBoards: [CircuitBoard] = []
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        let width = Int(self.frame.size.width)
        let height = Int(self.frame.size.height)
        
        //draw boards
        for board in circuitBoards {
            if let loc = board.location {
                board.color.set()
                let rect = CGRect(x: Int(loc.0 * (width/boxDimension)), y: Int(loc.1 * (height/boxDimension)), width: Int(board.width * (width/boxDimension)), height: Int(board.height * (height/boxDimension)))
                rect.fill()
            }
        }
        
        //draw grid
        let bPath:NSBezierPath = NSBezierPath()
        
        for i in 0...boxDimension {
            bPath.move(to: NSMakePoint(CGFloat((width/boxDimension) * i), CGFloat(0)))
            bPath.line(to: NSMakePoint(CGFloat((width/boxDimension) * i), CGFloat(height)))
        }
        for i in 0...boxDimension {
            bPath.move(to: NSMakePoint(CGFloat(0), CGFloat((height/boxDimension) * i)))
            bPath.line(to: NSMakePoint(CGFloat(width), CGFloat((height/boxDimension) * i)))
        }
        
        NSColor.black.set()
        bPath.stroke()
        
    }
    
}
