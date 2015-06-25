//
//  Array+Extensions.swift
//  Fitness
//
//  Created by Manuel Stampfl on 25.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

extension Array {
    mutating func moveFromIndex(index: Int, toIndex: Int) -> Bool {
        if index < 0 || index >= self.count || toIndex < 0 || toIndex >= self.count {
            return false
        }
        
        let value = self[index]
        self.removeAtIndex(index)
        self.insert(value, atIndex: toIndex)
        return true
    }
}