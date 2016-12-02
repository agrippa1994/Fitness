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
    fileprivate static var healthSingleTon: Health!
    var healthStore = HKHealthStore()
    
    fileprivate init() {
        
    }
    
    class func sharedHealth() -> Health {
        if healthSingleTon == nil {
            healthSingleTon = Health()
        }
        
        return healthSingleTon
    }
    
    func isAllowedToUse(_ completion: ((Bool) -> Void)?) {
        if !HKHealthStore.isHealthDataAvailable() {
            completion?(false)
            return
        }
        
        let writeTypes = Set<HKSampleType>(arrayLiteral: HKSampleType.workoutType())
        self.healthStore.requestAuthorization(toShare: writeTypes, read: nil) { success, error in
            if error != nil {
                NSLog("Error while requesting HealthKit authorization: \(error)")
            }
            
            completion?(success)
        }
    }
    
    func addWorkout(_ start: Date, end: Date, completion: ((Bool) -> Void)?) {
        let workout = HKWorkout(activityType: .crossTraining, start: start, end: end)
        self.healthStore.save(workout, withCompletion: { success, error in
            if error != nil {
                NSLog("Error while saving workout object to HealthKit: \(error)")
            }
            
            completion?(success)
        }) 
    }
}
