//
//  CoreData.swift
//  Fitness
//
//  Created by Manuel Stampfl on 11.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import Foundation
import CoreData

private var g_coreData: CoreData?

class CoreData {
    
    lazy var url: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let fileUrl = NSBundle.mainBundle().URLForResource("Storage", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: fileUrl)!
    }()
    
    lazy var persistanteStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.url.URLByAppendingPathComponent("Storage.sqlite")
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            NSLog("Error while adding persistent store \(error)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistanteStoreCoordinator
        return managedObjectContext
    }()
    
    class func initialize() {
        if g_coreData == nil {
            g_coreData = CoreData()
        }
    }
    
    class var shared: CoreData {
        return g_coreData!
    }
    
    class func save() -> Bool {
        guard let ctx = g_coreData?.managedObjectContext else {
            return false
        }
        
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                NSLog("Error while saving in CoreData \(error)")
                return false
            }
        }
        
        return true
    }
    
    var training = EntityHelper<Training>(name: "Training")
    var exercise = EntityHelper<Exercise>(name: "Exercise")
    
    var trainingManager: TrainingManager {
        let helper = EntityHelper<TrainingManager>(name: "TrainingManager")
        let all = helper.all()
        if all.count >= 1 {
            return all[0]
        }
        
        return helper.create(true)!
    }
}
