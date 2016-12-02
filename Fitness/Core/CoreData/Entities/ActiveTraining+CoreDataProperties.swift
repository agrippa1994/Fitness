//
//  ActiveTraining+CoreDataProperties.swift
//  Fitness
//
//  Created by Manuel Leitold on 12.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ActiveTraining {

    @NSManaged var currentStep: Int32
    @NSManaged var fireDate: TimeInterval
    @NSManaged var startDate: TimeInterval
    @NSManaged var manager: TrainingManager?
    @NSManaged var currentExercise: Exercise?
    @NSManaged var currentTraining: Training?

}
