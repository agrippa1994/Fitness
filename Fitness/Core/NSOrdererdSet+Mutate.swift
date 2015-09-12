//
//  NSOrdererdSet+Mutate.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import Foundation

extension NSOrderedSet {
    convenience init(setToMutate: NSOrderedSet, mutator: (NSMutableOrderedSet -> Void)) {
        let copy = setToMutate.mutableCopy() as! NSMutableOrderedSet
        mutator(copy)
        
        self.init(orderedSet: copy)
    }
}
