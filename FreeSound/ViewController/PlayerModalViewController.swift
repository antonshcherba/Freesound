//
//  PlayerModalViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/13/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class PlayerModalViewController: UIViewController {

    
    @IBOutlet weak var soundImageView: UIImageView!
    
    var soundImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundImageView.image = soundImage
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
