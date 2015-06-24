//
//  ExercisePrepareViewController.swift
//  Fitness
//
//  Created by Manuel Stampfl on 23.06.15.
//  Copyright (c) 2015 mani1337. All rights reserved.
//

import UIKit

class ExercisePrepareViewController: UIViewController {

    @IBOutlet weak var trainingNameLabel: UILabel!
    
    @IBAction func onGoButton(sender: AnyObject) {
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController2") as! UIViewController
        
        self.navigationController!.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
