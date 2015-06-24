//
//  Exercise.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit
import Foundation

enum ExerciseType: Int {
    case Running = 0, Breast, Back, Triceps, Biceps, Legs, Calves, Shoulders, Stomach, LowerBack, Pause, Count
    
    func localizedName() -> String {
        return NSLocalizedString(self.localizationKey(), comment: "Enumeration to string")
    }
    
    private func localizationKey() -> String {
        switch self {
        case .Running:
            return "EXERCISETYPE_RUNNING"
            
        case .Breast:
            return "EXERCISETYPE_BREAST"
            
        case .Back:
            return "EXERCISETYPE_BACK"
            
        case .Triceps:
            return "EXERCISETYPE_TRICEPS"
            
        case .Biceps:
            return "EXERCISETYPE_BICEPS"
            
        case .Legs:
            return "EXERCISETYPE_LEGS"
            
        case .Calves:
            return "EXERCISETYPE_CALVES"
            
        case .Shoulders:
            return "EXERCISETYPE_SHOULDERS"
            
        case .Stomach:
            return "EXERCISETYPE_STOMACH"
            
        case .LowerBack:
            return "EXERCISETYPE_LOWERBACK"
            
        case .Pause:
            return "EXERCISETYPE_PAUSE"
        default:
            return ""
        }
    }
}

class Exercise: NSObject, NSCoding {
    // MARK: - Internal vars
    var warmupTime: NSTimeInterval = 0
    var trainingTime: NSTimeInterval = 0
    var type: ExerciseType = .Running
    
    // MARK: - NSCoding
    @objc required init(coder aDecoder: NSCoder) {
        self.warmupTime = aDecoder.decodeObjectForKey("warmupTime") as! NSTimeInterval
        self.trainingTime = aDecoder.decodeObjectForKey("trainingTime") as! NSTimeInterval
        self.type = ExerciseType(rawValue: aDecoder.decodeObjectForKey("type") as! Int)!
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.warmupTime, forKey: "warmupTime")
        aCoder.encodeObject(self.trainingTime, forKey: "trainingTime")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
    }
}