//
//  LeftMenuViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class LeftMenuViewController : UITableViewController {
    
    // MARK: - Variables
    
    var selectedIndexPath = IndexPath(row: 0, section: 1)
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    let storyboardIDs = [StoryboardID.soundsViewController,
                         StoryboardID.profileViewController]
    
    // MARK: - Private Properties
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    func logoutUser() {
        let service = FreesoundService()
        service.logoutUser { (error) in
            print(error?.localizedDescription)
            
            self.sideMenuViewController.dismiss(animated: true, completion: nil)
            self.sideMenuViewController.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension LeftMenuViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return storyboardIDs.count
        case 2:
            return 1
        default:
            return 0
        }
        
    }
}


// MARK: - UITableViewDelegate
extension LeftMenuViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let id = storyboardIDs[indexPath.row]
            sideMenuViewController.setContentViewController(storyboard?.instantiateViewController(withIdentifier: id), animated: true)
            selectedIndexPath = indexPath
            sideMenuViewController.hideViewController()
        case 2:
            self.logoutUser()
        default:
            break
        }
    }
}
