//
//  ActiveTraining.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import Foundation
import CoreData

@objc(ActiveTraining)
class ActiveTraining: NSManagedObject {

    func startTraining(training: Training) -> Bool {
        if training.exercises!.count == 0 {
            return false
        }
        
        self.currentStep = 0
        self.fireDate = 0.0
        self.currentExercise = training.exercises!.objectAtIndex(0) as? Exercise
        self.currentTraining = training
        self.startDate = NSDate().timeIntervalSince1970
        return true
    }
}
