//
//  TrainingsTableViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

class TrainingsTableViewController: UITableViewController, EditTrainingTableViewControllerDelegate {
    // MARK: - Vars
    var currentSelectedIndexPath: NSIndexPath?
    var trainings: [Training] = [] {
        didSet {
            Storage.trainings = self.trainings
        }
    }
    
    // MARK: - Storyboard Actions
    @IBAction func onBarButtonItemAdd(sender: AnyObject) {
        if let vc: (UINavigationController, EditTrainingTableViewController) = self.storyboard?.instantiateNavigationControllerAndTopControllerWithIdentifier("EditTrainingTableViewController") {
            vc.1.delegate = self
            self.presentViewController(vc.0, animated: true, completion: nil)
        }
    }
    // MARK: - Overrided Base Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch all trainings from the persistent storage
        self.trainings = Storage.trainings
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.tableView.allowsSelectionDuringEditing = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trainings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrainingCell", forIndexPath: indexPath) 

        let training = self.trainings[indexPath.row]
        let minutes = training.exerciseDuration / 60
        let seconds = training.exerciseDuration % 60
        
        cell.textLabel?.text = training.name
        cell.detailTextLabel?.text = String(format: NSLocalizedString("TRAININGSTABLEVIEWCONTROLLER_DURATION", comment: "duration"), arguments: [minutes, seconds])
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.currentSelectedIndexPath = indexPath
        
        // If the table view is in editing mode, the selected training should be edited
        if tableView.editing {
            if let vc: (UINavigationController, EditTrainingTableViewController) = self.storyboard?.instantiateNavigationControllerAndTopControllerWithIdentifier("EditTrainingTableViewController") {
                vc.1.delegate = self
                vc.1.training = <-self.trainings[indexPath.row] // Create a copy!! Swift copies objects via ARC
                
                self.presentViewController(vc.0, animated: true, completion: nil)
            }
        }
        // Otherwise start a training
        else {
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ExerciseNavigationController") as? ExerciseNavigationController {
                vc.training = <-self.trainings[indexPath.row]
                
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
 
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }
        
        self.trainings.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        self.trainings.moveFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // MARK: - EditTrainingTableViewControllerDelegate
    func editTrainingTableViewDidCancelled(controller: EditTrainingTableViewController) {
        controller.dismissViewControllerAnimated(true) {
            if self.currentSelectedIndexPath != nil {
                self.tableView.deselectRowAtIndexPath(self.currentSelectedIndexPath!, animated: true)
                self.currentSelectedIndexPath = nil
            }
        }
    }
    
    func editTrainingTableViewDidFinished(controller: EditTrainingTableViewController) {
        if self.currentSelectedIndexPath != nil {
            self.trainings[self.currentSelectedIndexPath!.row] = controller.training
        } else {
            self.trainings += [controller.training]
        }
        
        controller.dismissViewControllerAnimated(true) {
            if self.currentSelectedIndexPath != nil {
                self.tableView.deselectRowAtIndexPath(self.currentSelectedIndexPath!, animated: true)
                self.currentSelectedIndexPath = nil
            }
        }
        
        self.tableView.reloadData()
    }
}
