//
//  Training.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import Foundation
import CoreData

@objc(Training)
class Training: NSManagedObject {

    func createExercise() -> Exercise {
        let exercise = EntityHelper<Exercise>(name: "Exercise").create(true)!
        self.addExercise(exercise)
    
        return exercise
    }
    
    func addExercise(exercise: Exercise) {
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.addObject(exercise)
        }
        
        exercise.training = self
    }
    
    func moveExerciseFromIndex(fromIndex: Int, toIndex index: Int) {
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.moveObjectsAtIndexes(NSIndexSet(index: fromIndex), toIndex: index)
        }
    }
    
    func removeExerciseAtIndex(index: Int) {
        EntityHelper<Exercise>(name: "Exercise").remove(self.exercises!.objectAtIndex(index) as! Exercise)
        
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.removeObjectAtIndex(index)
        }
    }
    
    func removeExercise(exercise: Exercise) {
        EntityHelper<Exercise>(name: "Exercise").remove(exercise)
        
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.removeObject(exercise)
        }
    }
}
