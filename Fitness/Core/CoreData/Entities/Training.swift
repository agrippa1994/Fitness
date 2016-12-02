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
    
    func addExercise(_ exercise: Exercise) {
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.add(exercise)
        }
        
        exercise.training = self
    }
    
    func moveExerciseFromIndex(_ fromIndex: Int, toIndex index: Int) {
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.moveObjects(at: IndexSet(integer: fromIndex), to: index)
        }
    }
    
    func removeExerciseAtIndex(_ index: Int) {
        EntityHelper<Exercise>(name: "Exercise").remove(self.exercises!.object(at: index) as! Exercise)
        
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.removeObject(at: index)
        }
    }
    
    func removeExercise(_ exercise: Exercise) {
        EntityHelper<Exercise>(name: "Exercise").remove(exercise)
        
        self.exercises = NSOrderedSet(setToMutate: self.exercises!) {
            $0.remove(exercise)
        }
    }
}
