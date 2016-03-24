//
//  TrainingTableViewController.swift
//  Fitness
//
//  Created by Manuel Leitold on 11.09.15.
//  Copyright © 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

class TrainingTableViewController: UITableViewController, InputTableViewCellDelegate {
    
    var training: Training!
    var activeTrainingController: ActiveTrainingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.editing = true
        self.tableView.allowsSelectionDuringEditing = true
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
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, self.training.exercises!.count, 1][section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            let newCell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as! InputTableViewCell
            
            newCell.delegate = self
            newCell.textField.text = self.training.name
            
            cell = newCell
            
        case 1:
            let exercise = self.training.exercises!.objectAtIndex(indexPath.row) as! Exercise
            let newCell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath)
            
            newCell.textLabel?.text = ExerciseType(rawValue: exercise.exerciseType)?.localizedName()
            newCell.detailTextLabel?.text = Int(exercise.duration).asTime
                
            cell = newCell
            
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("StartTrainingCell", forIndexPath: indexPath)
            
        default:
            cell = UITableViewCell()
            break
        }
    
        return cell
    }
    

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.section == 1
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }
        
        // Remove exercise object from the training
        self.training.removeExerciseAtIndex(indexPath.row)
        
        // Remove data from TableView
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        CoreData.save()
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // Move object in CoreData
        self.training!.moveExerciseFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
        CoreData.save()
    }

    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.section != 1 {
            return NSIndexPath(forItem: sourceIndexPath.row, inSection: 1)
        }
        
        return proposedDestinationIndexPath
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "TRAININGTABLEVIEWCONTROLLER_NAME_HEADER".localized
        case 1:
            return "TRAININGTABLEVIEWCONTROLLER_EXERCISES_HEADER".localized
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Start training
        if indexPath.section == 2 && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.startTraining(self.training)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? ExerciseTableViewController where segue.identifier != nil {
            switch segue.identifier! {
            case "Add":
                controller.exercise = self.training.createExercise()
                
            case "Edit" where sender is UITableViewCell:
                let index = self.tableView.indexPathForCell(sender as! UITableViewCell)!.row
                controller.exercise = self.training.exercises!.objectAtIndex(index) as! Exercise
                
            default:
                break
            }
        }
    }
    
    func inputTableViewCell(cell: InputTableViewCell, didChangedText newText: String) {
        self.training.name = newText
    }
    
    func startTraining(training: Training) {
        if self.training.exercises!.count == 0 {
            let controller = UIAlertController(title: "ERROR".localized, message: "TRAININGTABLEVIEWCONTROLLER_NO_EXERCISES".localized, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            return self.presentViewController(controller, animated: true, completion: nil)
        }
        
        let activeTraining = CoreData.shared.createActiveTrainingOrGetActive()
        activeTraining.startTraining(training)
        self.activeTrainingController = ActiveTrainingController(withStoryboard: self.storyboard!, andActiveTraining: activeTraining)
        self.activeTrainingController!.startViaController(self)
        CoreData.save()
    }
}
