//
//  TrainingsTableViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 24.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

class TrainingsTableViewController: UITableViewController, EditTrainingTableViewControllerDelegate {
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

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrainingCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
 
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete {
            return
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func editTrainingTableViewDidCancelled(controller: EditTrainingTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editTrainingTableViewDidFinished(controller: EditTrainingTableViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
