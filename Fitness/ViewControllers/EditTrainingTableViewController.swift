//
//  EditTrainingTableViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

@objc protocol EditTrainingTableViewControllerDelegate {
    func editTrainingTableViewDidCancelled(controller: EditTrainingTableViewController)
    func editTrainingTableViewDidFinished(controller: EditTrainingTableViewController)
}

class EditTrainingTableViewController: UITableViewController, EditExerciseTableViewControllerDelegate, InputTableViewCellDelegate {
    // MARK: - Vars
    weak var delegate: EditTrainingTableViewControllerDelegate?
    var training = Training()
    var currentSelectedIndexPath: NSIndexPath?
    
    // Storyboard Actions
    @IBAction func onBarButtonItemSave(sender: AnyObject) {
        if self.training.name.isEmpty || self.training.exercises.isEmpty {
            let title = NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_INVALID_DATA_TITLE", comment: "title")
            let message = NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_INVALID_DATA_TEXT", comment: "text")
            let ack = NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_INVALID_DATA_ACK", comment: "ack")
            
            return UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: ack).show()
        }
        
        self.delegate?.editTrainingTableViewDidFinished(self)
    }
 
    @IBAction func onBarButtonItemClose(sender: AnyObject) {
        self.delegate?.editTrainingTableViewDidCancelled(self)
    }
    
    // MARK: - Overrided Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Always in editing mode and allow cell selection while being in this mode
        self.editing = true
        self.tableView.allowsSelectionDuringEditing = true
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return self.training.exercises.count
        }
        if section == 2 {
            return 1
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as! InputTableViewCell
            cell.delegate = self
            cell.inputText = self.training.name
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell", forIndexPath: indexPath) as! UITableViewCell
            
            var exercise = self.training.exercises[indexPath.row]
            let minutes = exercise.duration / 60
            let seconds = exercise.duration % 60
            
            cell.textLabel?.text = exercise.type.localizedName()
            cell.detailTextLabel?.text = String(format: NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_DURATION", comment: "duration"), arguments: [minutes, seconds])
            
            return cell
        }
        
        if indexPath.section == 2 {
            return tableView.dequeueReusableCellWithIdentifier("AddExerciseCell", forIndexPath: indexPath) as! UITableViewCell
        }
        
        // This point should never be reached so we don't care what we return
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentSelectedIndexPath = indexPath
        
        if let vc: (UINavigationController, EditExerciseTableViewController) = self.storyboard?.instantiateNavigationControllerAndTopControllerWithIdentifier("EditExerciseTableViewController") {
            
            vc.1.delegate = self
            
            // Set the exercise
            if indexPath.section == 1 {
                vc.1.exercise = <-self.training.exercises[indexPath.row]
            }
            
            self.presentViewController(vc.0, animated: true, completion: nil)
        }
    }
  
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Only exercises can be edited
        return indexPath.section == 1
    }
 
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }
        
        self.training.exercises.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }

    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if proposedDestinationIndexPath.section != 1 {
            return NSIndexPath(forRow: tableView.numberOfRowsInSection(sourceIndexPath.section) - 1, inSection: sourceIndexPath.section)
        }
        
        return proposedDestinationIndexPath
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        self.training.exercises.moveFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Only exercises can be moved
        return indexPath.section == 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_SECTION_0", comment: "Section 0")
        case 1:
            return NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_SECTION_1", comment: "Section 1")
        default:
            return ""
        }
    }

    // MARK: - EditExerciseTableViewControllerDelegate
    func editExerciseTableViewControllerDidCancelled(controller: EditExerciseTableViewController) {
        controller.dismissViewControllerAnimated(true) {
            if self.currentSelectedIndexPath != nil {
                self.tableView.deselectRowAtIndexPath(self.currentSelectedIndexPath!, animated: true)
                self.currentSelectedIndexPath = nil
            }
        }
    }
    
    func editExerciseTableViewControllerDidFinished(controller: EditExerciseTableViewController) {
        if self.currentSelectedIndexPath != nil && controller.exercise != nil {
            if self.currentSelectedIndexPath!.section == 0 {
                self.training.exercises[self.currentSelectedIndexPath!.row] = controller.exercise!
            } else {
                self.training.exercises.append(controller.exercise!)
            }
        }
        
        controller.dismissViewControllerAnimated(true) {
            if self.currentSelectedIndexPath != nil {
                self.tableView.deselectRowAtIndexPath(self.currentSelectedIndexPath!, animated: true)
                self.currentSelectedIndexPath = nil
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - InputTableViewCellDelegate
    func inputTableViewCell(cell: InputTableViewCell, didChangedText newText: String) {
        self.training.name = newText
    }
}
