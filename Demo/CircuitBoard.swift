//
//  CircuitBoard.swift
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

class CircuitBoard: NSObject {  //get hashable for free and dynamic access
    @objc var height: Int = 1
    @objc var width: Int = 1
    @objc var color: NSColor = NSColor.red
    var location: (Int, Int)?
    
    //generate the domain as a list of tuples of bottom left corners
    func generateDomain(boardWidth: Int, boardHeight: Int) -> [(Int, Int)] {
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
