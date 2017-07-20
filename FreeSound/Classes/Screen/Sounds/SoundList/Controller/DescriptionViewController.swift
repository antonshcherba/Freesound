//
//  DescriptionViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/19/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class DescriptionViewController : UIViewController {
    
    // MARK: - Variables
    var shortDescription: String!
    
    // MARK: - Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionTextView.text = shortDescription
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: view)
        
        if !descriptionTextView.frame.contains(tapPoint) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Private methods
    
}
