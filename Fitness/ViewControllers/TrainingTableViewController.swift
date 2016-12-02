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
        
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CoreData.save()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CoreData.save()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, self.training.exercises!.count, 1][section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        switch indexPath.section {
        case 0:
            let newCell = tableView.dequeueReusableCell(withIdentifier: "InputCell", for: indexPath) as! InputTableViewCell
            
            newCell.delegate = self
            newCell.textField.text = self.training.name
            
            cell = newCell
            
        case 1:
            let exercise = self.training.exercises!.object(at: indexPath.row) as! Exercise
            let newCell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
            
            newCell.textLabel?.text = ExerciseType(rawValue: exercise.exerciseType)?.localizedName()
            newCell.detailTextLabel?.text = Int(exercise.duration).asTime
                
            cell = newCell
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "StartTrainingCell", for: indexPath)
            
        default:
            cell = UITableViewCell()
            break
        }
    
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        
        // Remove exercise object from the training
        self.training.removeExerciseAtIndex(indexPath.row)
        
        // Remove data from TableView
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        CoreData.save()
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        // Move object in CoreData
        self.training!.moveExerciseFromIndex(fromIndexPath.row, toIndex: toIndexPath.row)
        CoreData.save()
    }

    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section != 1 {
            return IndexPath(item: sourceIndexPath.row, section: 1)
        }
        
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "TRAININGTABLEVIEWCONTROLLER_NAME_HEADER".localized
        case 1:
            return "TRAININGTABLEVIEWCONTROLLER_EXERCISES_HEADER".localized
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Start training
        if indexPath.section == 2 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            self.startTraining(self.training)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ExerciseTableViewController, segue.identifier != nil {
            switch segue.identifier! {
            case "Add":
                controller.exercise = self.training.createExercise()
                
            case "Edit" where sender is UITableViewCell:
                let index = self.tableView.indexPath(for: sender as! UITableViewCell)!.row
                controller.exercise = self.training.exercises!.object(at: index) as! Exercise
                
            default:
                break
            }
        }
    }
    
    func inputTableViewCell(_ cell: InputTableViewCell, didChangedText newText: String) {
        self.training.name = newText
    }
    
    func startTraining(_ training: Training) {
        if self.training.exercises!.count == 0 {
            let controller = UIAlertController(title: "ERROR".localized, message: "TRAININGTABLEVIEWCONTROLLER_NO_EXERCISES".localized, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            return self.present(controller, animated: true, completion: nil)
        }
        
        let activeTraining = CoreData.shared.createActiveTrainingOrGetActive()
        activeTraining.startTraining(training)
        self.activeTrainingController = ActiveTrainingController(withStoryboard: self.storyboard!, andActiveTraining: activeTraining)
        self.activeTrainingController!.startViaController(self)
        CoreData.save()
    }
}
