//
//  MainTableViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 11.09.15.
//  Copyright © 2015 mani1337. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    var trainingManager: TrainingManager {
        return CoreData.shared.trainingManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CoreData.save()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        CoreData.save()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.trainingManager.trainings?.count else {
            return 0
        }
        
        return count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrainingCell", forIndexPath: indexPath)

        let training = self.trainingManager.trainings!.objectAtIndex(indexPath.row)
        cell.textLabel?.text = training.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        defer {
            CoreData.save()
        }
        
        if editingStyle != .Delete {
            return
        }
        
        // Remove data from CoreData
        let set = self.trainingManager.trainings!.mutableCopy() as! NSMutableOrderedSet
        set.removeObjectAtIndex(indexPath.row)
        self.trainingManager.trainings = NSMutableOrderedSet(orderedSet: set)
        
        // Remove data from TableView
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        defer {
            CoreData.save()
        }
        
        // Move object in CoreData
        let set = self.trainingManager.trainings!.mutableCopy() as! NSMutableOrderedSet
        set.moveObjectsAtIndexes(NSIndexSet(index: fromIndexPath.row), toIndex: toIndexPath.row)
        self.trainingManager.trainings! = NSMutableOrderedSet(orderedSet: set)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? TrainingTableViewController where segue.identifier != nil {
            switch segue.identifier! {
            case "Add":
                controller.training = CoreData.shared.training.create(true)
                controller.training.name = "Unnamed"
                controller.training.manager = self.trainingManager
                
            case "Edit" where sender is UITableViewCell:
                let index = self.tableView.indexPathForCell(sender as! UITableViewCell)!.row
                controller.training = self.trainingManager.trainings!.objectAtIndex(index) as! Training
                
            default:
                break
            }
        }
    }
}
