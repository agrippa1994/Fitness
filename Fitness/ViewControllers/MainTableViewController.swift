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
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreData.save()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Health.sharedHealth().isAllowedToUse {
            NSLog("Access to HealthKit \($0)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CoreData.save()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreData.shared.trainingManager.trainings!.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingCell", for: indexPath)

        let training = CoreData.shared.trainingManager.trainings!.object(at: indexPath.row)
        cell.textLabel?.text = (training as AnyObject).name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        defer {
            CoreData.save()
        }
        
        if editingStyle != .delete {
            return
        }
        
        // Remove data from CoreData
        CoreData.shared.trainingManager.removeTrainingAtIndex(indexPath.row)
        
        // Remove data from TableView
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        defer {
            CoreData.save()
        }
        
        // Move object in CoreData
       CoreData.shared.trainingManager.moveTrainingFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? TrainingTableViewController, segue.identifier != nil {
            switch segue.identifier! {
            case "Add":
                controller.training = CoreData.shared.trainingManager.createTraining()
                
            case "Edit" where sender is UITableViewCell:
                let index = self.tableView.indexPath(for: sender as! UITableViewCell)!.row
                controller.training = CoreData.shared.trainingManager.trainings!.object(at: index) as! Training
                
            default:
                break
            }
        }
    }
}
