//
//  CoreData.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import Foundation
import CoreData
import CoreSpotlight
import MobileCoreServices

private var g_coreData: CoreData?

class CoreData {
    
    lazy var url: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let fileUrl = Bundle.main.url(forResource: "Storage", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: fileUrl)!
    }()
    
    lazy var persistanteStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.url.appendingPathComponent("Storage.sqlite")
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            NSLog("Error while adding persistent store \(error)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
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
    
    class func save() -> Void {
        guard let ctx = g_coreData?.managedObjectContext else {
            return
        }
        
        // Update Spotlight entries
        let index = CSSearchableIndex.default()
        index.deleteAllSearchableItems { error in
            if error != nil {
                return NSLog("Error while deleting all searchable items \(error)")
            }
            
            var searchableItems = [CSSearchableItem]()
            for obj in CoreData.shared.trainingManager.trainings! {
                let training = obj as! Training
                
                let attributeSet = CSSearchableItemAttributeSet(itemContentType: String(kUTTypeText))
                attributeSet.title = training.name!
                searchableItems += [CSSearchableItem(uniqueIdentifier: training.name!, domainIdentifier: nil, attributeSet: attributeSet)]
            }
            
            index.indexSearchableItems(searchableItems) { error in
                if error != nil {
                    return NSLog("Error while indexing searchable items \(error)")
                }
            }
            
        }
        
        for obj in CoreData.shared.trainingManager.trainings! {
            let training = obj as! Training
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: training.name!)
            let searchableItem = CSSearchableItem(uniqueIdentifier: training.name!, domainIdentifier: nil, attributeSet: attributeSet)
            index.indexSearchableItems([searchableItem], completionHandler: nil)
        }
        
        // Save
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                NSLog("Error while saving in CoreData \(error)")
                return
            }
        }
        
        return
    }
    
    lazy var trainingManager: TrainingManager = {
        let helper = EntityHelper<TrainingManager>(name: "TrainingManager")
        let all = helper.all()
        if all.count >= 1 {
            return all[0]
        }
        
        return helper.create(true)!
    }()
    
    func createActiveTrainingOrGetActive() -> ActiveTraining {
        if self.activeTraining != nil {
            return self.activeTraining!
        }
        
        let training = EntityHelper<ActiveTraining>(name: "ActiveTraining").create(true)!
        training.manager = self.trainingManager
        
        return training
    }
    
    var activeTraining: ActiveTraining? {
        get {
            let objects = EntityHelper<ActiveTraining>(name: "ActiveTraining").all()
            if objects.count == 0 {
                return nil
            }
            
            return objects[0]
            
        } set {
            if let training = self.activeTraining, newValue == nil {
                EntityHelper<ActiveTraining>(name: "ActiveTraining").remove(training)
            }
        }
    }
    
}
