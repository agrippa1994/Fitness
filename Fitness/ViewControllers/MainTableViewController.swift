//
//  MainTableViewController.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CoreData.save()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Health.sharedHealth().isAllowedToUse {
            NSLog("Access to HealthKit \($0)")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        CoreData.save()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreData.shared.trainingManager.trainings!.count
    }
        
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrainingCell", forIndexPath: indexPath)

        let training = CoreData.shared.trainingManager.trainings!.objectAtIndex(indexPath.row)
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
        CoreData.shared.trainingManager.removeTrainingAtIndex(indexPath.row)
        
        // Remove data from TableView
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        defer {
            CoreData.save()
        }
        
        // Move object in CoreData
       CoreData.shared.trainingManager.moveTrainingFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? TrainingTableViewController where segue.identifier != nil {
            switch segue.identifier! {
            case "Add":
                controller.training = CoreData.shared.trainingManager.createTraining()
                
            case "Edit" where sender is UITableViewCell:
                let index = self.tableView.indexPathForCell(sender as! UITableViewCell)!.row
                controller.training = CoreData.shared.trainingManager.trainings!.objectAtIndex(index) as! Training
                
            default:
                break
            }
        }
    }
}
