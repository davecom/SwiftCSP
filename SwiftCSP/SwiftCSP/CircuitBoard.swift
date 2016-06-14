//
//  CircuitBoard.swift
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

class CircuitBoard: NSObject {  //get hashable for free and dynamic access
    var height: Int = 1
    var width: Int = 1
    var color: NSColor = NSColor.red()
    var location: (Int, Int)?
    
    //generate the domain as a list of tuples of bottom left corners
    func generateDomain(_ boardWidth: Int, boardHeight: Int) -> [(Int, Int)] {
        var domain: [(Int, Int)] = []
        for x in 0..<(boardWidth - width + 1) {
            for y in 0..<(boardHeight - height + 1) {
                let temp = (x, y)
                domain.append(temp)
            }
        }
        return domain
    }
}
