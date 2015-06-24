//
//  Copier.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

// The <- operator can deep copy Swift classes but it should only be used if it's really necessary due to the long processing time
prefix operator <- {}

prefix func <- <T where T: NSObject, T: NSCoding>(obj: T) -> T {
    return NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(obj)) as! T
}