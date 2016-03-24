//
//  Health.swift
//  Fitness
//
//  Created by Manuel Leitold on 13.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import Foundation
import HealthKit

class Health {
    private static var healthSingleTon: Health!
    var healthStore = HKHealthStore()
    
    private init() {
        
    }
    
    class func sharedHealth() -> Health {
        if healthSingleTon == nil {
            healthSingleTon = Health()
        }
        
        return healthSingleTon
    }
    
    func isAllowedToUse(completion: (Bool -> Void)?) {
        if !HKHealthStore.isHealthDataAvailable() {
            completion?(false)
            return
        }
        
        let writeTypes = Set<HKSampleType>(arrayLiteral: HKSampleType.workoutType())
        self.healthStore.requestAuthorizationToShareTypes(writeTypes, readTypes: nil) { success, error in
            if error != nil {
                NSLog("Error while requesting HealthKit authorization: \(error)")
            }
            
            completion?(success)
        }
    }
    
    func addWorkout(start: NSDate, end: NSDate, completion: (Bool -> Void)?) {
        let workout = HKWorkout(activityType: .CrossTraining, startDate: start, endDate: end)
        self.healthStore.saveObject(workout) { success, error in
            if error != nil {
                NSLog("Error while saving workout object to HealthKit: \(error)")
            }
            
            completion?(success)
        }
    }
}
