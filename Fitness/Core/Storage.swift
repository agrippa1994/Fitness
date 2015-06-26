//
//  Storage.swift
//  Fitness
//
//  Created by Manuel Stampfl on 26.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

private var defaults = NSUserDefaults(suiteName: "group.at.mani1337.Fitness")

private func readObjectForKey(key: String) -> AnyObject? {
    if let object = defaults?.objectForKey(key) as? NSData {
        return NSKeyedUnarchiver.unarchiveObjectWithData(object)
    }
    
    return nil
}

private func writeObjectForKey(key: String, object: AnyObject) -> Bool {
    if defaults == nil {
        return false
    }
    
    defaults!.setObject(NSKeyedArchiver.archivedDataWithRootObject(object), forKey: key)
    return defaults!.synchronize()
}

class Storage {
    class var trainings: [Training] {
        get {
            if let data = readObjectForKey("trainings") as? [Training] {
                return data
            }
            
            return []
        } set {
            writeObjectForKey("trainings", newValue)
        }
    }
}