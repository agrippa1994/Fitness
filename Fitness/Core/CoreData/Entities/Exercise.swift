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
    case running = 0, breast, back, triceps, biceps, legs, calves, shoulders, stomach, lowerBack, pause, count
    
    func localizedName() -> String {
        return NSLocalizedString(self.localizationKey(), comment: "Enumeration to string")
    }
    
    private func localizationKey() -> String {
        switch self {
        case .running:
            return "EXERCISETYPE_RUNNING"
            
        case .breast:
            return "EXERCISETYPE_BREAST"
            
        case .back:
            return "EXERCISETYPE_BACK"
            
        case .triceps:
            return "EXERCISETYPE_TRICEPS"
            
        case .biceps:
            return "EXERCISETYPE_BICEPS"
            
        case .legs:
            return "EXERCISETYPE_LEGS"
            
        case .calves:
            return "EXERCISETYPE_CALVES"
            
        case .shoulders:
            return "EXERCISETYPE_SHOULDERS"
            
        case .stomach:
            return "EXERCISETYPE_STOMACH"
            
        case .lowerBack:
            return "EXERCISETYPE_LOWERBACK"
            
        case .pause:
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
