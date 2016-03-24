//
//  Exercise.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import Foundation
import CoreData

enum ExerciseType: Int32 {
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

@objc(Exercise)
class Exercise: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

}
