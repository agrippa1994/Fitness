//
//  Training.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import Foundation

class Training: NSObject, NSCoding {
    // MARK: - Internal vars
    var name: String = ""
    var exercises: [Exercise] = []
    
    // MARK: - NSCoding
    @objc required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.exercises = aDecoder.decodeObjectForKey("exercises") as! [Exercise]
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.exercises, forKey: "exercises")
    }
    
    // MARK: - Initializers
    override init() {
    }
    
    // MARK: - Methods
    var exerciseDuration: NSTimeInterval {
        var duration: NSTimeInterval = 0.0
        for exercise in self.exercises {
            duration += exercise.duration
        }
        
        return duration
    }
}