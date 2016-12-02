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
    
    func addTraining(_ training: Training) {
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.add(training)
        }
        
        training.manager = self
    }

    func moveTrainingFromIndex(_ fromIndex: Int, toIndex index: Int) {
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.moveObjects(at: IndexSet(integer: fromIndex), to: index)
        }
    }
    
    func removeTrainingAtIndex(_ index: Int) {
        EntityHelper<Training>(name: "Training").remove(self.trainings!.object(at: index) as! Training)
        
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.removeObject(at: index)
        }
    }
    
    func removeTraining(_ training: Training) {
        EntityHelper<Training>(name: "Training").remove(training)
        
        self.trainings = NSOrderedSet(setToMutate: self.trainings!) {
            $0.remove(training)
        }
    }
}
