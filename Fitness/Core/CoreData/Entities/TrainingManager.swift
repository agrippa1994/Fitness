//
//  TrainingManager.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import Foundation
import CoreData

@objc(TrainingManager)
class TrainingManager: NSManagedObject {

    func createTraining() -> Training {
        let training = EntityHelper<Training>(name: "Training").create(true)!
        self.addTraining(training)
        return training
    }
    
    func addTraining(training: Training) {
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.addObject(training)
        }
        
        training.manager = self
    }

    func moveTrainingFromIndex(fromIndex: Int, toIndex index: Int) {
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.moveObjectsAtIndexes(NSIndexSet(index: fromIndex), toIndex: index)
        }
    }
    
    func removeTrainingAtIndex(index: Int) {
        EntityHelper<Training>(name: "Training").remove(self.trainings!.objectAtIndex(index) as! Training)
        
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.removeObjectAtIndex(index)
        }
    }
    
    func removeTraining(training: Training) {
        EntityHelper<Training>(name: "Training").remove(training)
        
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.removeObject(training)
        }
    }
}
