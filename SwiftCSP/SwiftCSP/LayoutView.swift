//
//  LayoutView.swift
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
                NSRectFill(rect)
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
        
        NSColor.black().set()
        bPath.stroke()
        
    }
    
}
