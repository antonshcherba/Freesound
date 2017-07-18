//
//  MenuRootViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import RESideMenu

class MenuRootViewController: RESideMenu {
    
    override func awakeFromNib() {
        parallaxEnabled = false
        
        contentViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.soundsViewController)
        leftMenuViewController = storyboard?.instantiateViewController(withIdentifier: StoryboardID.leftMenuViewController)
    }
}

extension UIViewController {

    func presentLeftViewController(_ sender: AnyObject) {
        sideMenuViewController.presentLeftMenuViewController()
    }
}
