//
//  Navigation.swift
//  FreeSound
//
//  Created by Anton Shcherba on 1/10/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

protocol Identifing {
    static var ID: String { get }
}

extension UIViewController {
    class var ID: String { return className }
}

extension UIView {
    class var ID: String { return className }
    
    static var nibbName: String { return className }
}

struct NibNames {
    
    // MARK: - general
    
    static var login : String {
        return "Login"
    }
}

protocol Storyboarding {
    static var storyboardName: String { get }
}

protocol Nibing {
    static var nibbName: String { get }
}

class NavigationManager {
}

typealias NibController = UIViewController & Nibing

extension NavigationManager {
    
    static func getController<T>(type: T.Type) -> T where T: NibController {
        let controller = T.init(nibName: T.nibbName, bundle: nil)
        return controller
    }
    
    static func getController<T>() -> T where T: NibController {
        let controller = T.init(nibName: T.nibbName, bundle: nil)
        return controller
    }
}

typealias StoryController = Storyboarding & UIViewController

typealias StoryIDController = Storyboarding & UIViewController & Identifing

extension NavigationManager {
    
    static func getController<T>(type: T.Type) -> T where T:StoryIDController {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: T.ID) as! T
    }
    
    static func getController<T>() -> T where T:StoryIDController {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: T.ID) as! T
    }
    
    static func getController<T>(type: T.Type) -> T where T:StoryController {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
    
    static func getController<T>() -> T where T:StoryController {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: nil)
        return storyboard.instantiateInitialViewController() as! T
    }
}

extension ProfileViewController: Storyboarding, Identifing {
    static var storyboardName = StoryboardName.profile
}

extension SoundListViewController: Storyboarding, Identifing {
    static var storyboardName = StoryboardName.soundList
}

extension UserSoundsController: Storyboarding, Identifing {
    static var storyboardName = StoryboardName.userSounds
}
