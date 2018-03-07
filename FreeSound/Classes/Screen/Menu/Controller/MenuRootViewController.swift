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
        
        var storyboard = UIStoryboard(name: StoryboardName.soundList, bundle: nil)
        contentViewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.soundsViewController)
        
        storyboard = UIStoryboard(name: StoryboardName.leftMenu, bundle: nil)
        leftMenuViewController = storyboard.instantiateViewController(withIdentifier: StoryboardID.leftMenuViewController)
    }
}

extension UIViewController {

    @objc func presentLeftViewController(_ sender: AnyObject) {
        sideMenuViewController.presentLeftMenuViewController()
    }
}
