//
//  ProfileViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class ProfileViewController : UIViewController {
    
    // MARK: - Variables
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var homepageLabel: UILabel!
    
    @IBOutlet weak var joinedDate: UILabel!
    
    @IBOutlet weak var soundsCountLabel: UILabel!
    
    @IBOutlet weak var packsCountLabel: UILabel!
    
    // MARK: - Public Properties
    
    var user: User!
    
    // MARK: - Private Properties
    
    fileprivate let loader = SoundLoader()
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.loadUser(withName: "me", authRequired: true) { (user) in
            DispatchQueue.main.async { [unowned self] in
                self.nameLabel.text = user.name
                self.avatarImageView.image = user.avatar
                self.homepageLabel.text = user.homepage
                self.joinedDate.text = user.joinedDate
                
//                self.soundsCountLabel.text = String(user.soundsCount)
//                self.packsCountLabel.text = String(user.packsCount)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
}
