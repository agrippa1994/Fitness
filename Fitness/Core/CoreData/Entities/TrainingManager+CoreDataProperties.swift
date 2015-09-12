//
//  TrainingManager+CoreDataProperties.swift
//  Fitness
//
//  Created by Manuel Stampfl on 12.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TrainingManager {

    @NSManaged var trainings: NSOrderedSet?
    @NSManaged var activeTraining: ActiveTraining?

}
