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
    
    var username = "me"
    
    // MARK: - Private Properties
    
    fileprivate let loader = SoundLoader()
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.loadUser(withName: username, authRequired: true) { (user) in
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
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        if let first = navigationController?.viewControllers.first, first != self {
            return
        }
        
        let searchSettingsButton = UIButton(type: .custom)
        searchSettingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchSettingsButton.setImage(UIImage(named: "SettingsButtonIcon"), for: .normal)
        searchSettingsButton.addTarget(self, action: #selector(presentLeftViewController(_:)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: searchSettingsButton);
        
        navigationItem.leftBarButtonItem = barItem
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
