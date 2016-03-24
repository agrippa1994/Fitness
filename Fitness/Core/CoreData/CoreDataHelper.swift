//
//  CoreDataHelper.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import CoreData

class EntityHelper<T where T: NSManagedObject> {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func all() -> [T] {
        let ctx = CoreData.shared.managedObjectContext
        if let data = try? ctx.executeFetchRequest(NSFetchRequest(entityName: self.name)) as? [T] {
            return data!
        }
        
        return []
    }
    
    func create(shouldSave: Bool = false) -> T? {
        let ctx = CoreData.shared.managedObjectContext
        if let desc = NSEntityDescription.entityForName(self.name, inManagedObjectContext: ctx) {
            return NSManagedObject(entity: desc, insertIntoManagedObjectContext: shouldSave ? ctx : nil) as? T
        }

        return nil
    }
    
    func insert(value: T) {
        let ctx = CoreData.shared.managedObjectContext
        ctx.insertObject(value)
    }
    
    func remove(value: T) {
        let ctx = CoreData.shared.managedObjectContext
        ctx.deleteObject(value)
    }
}
