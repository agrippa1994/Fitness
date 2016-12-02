//
//  CoreDataHelper.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import CoreData

class EntityHelper<T> where T: NSManagedObject {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func all() -> [T] {
        let ctx = CoreData.shared.managedObjectContext
        if let data = try? ctx.fetch(NSFetchRequest(entityName: self.name)) as? [T] {
            return data!
        }
        
        return []
    }
    
    func create(_ shouldSave: Bool = false) -> T? {
        let ctx = CoreData.shared.managedObjectContext
        if let desc = NSEntityDescription.entity(forEntityName: self.name, in: ctx) {
            return NSManagedObject(entity: desc, insertInto: shouldSave ? ctx : nil) as? T
        }

        return nil
    }
    
    func insert(_ value: T) {
        let ctx = CoreData.shared.managedObjectContext
        ctx.insert(value)
    }
    
    func remove(_ value: T) {
        let ctx = CoreData.shared.managedObjectContext
        ctx.delete(value)
    }
}
