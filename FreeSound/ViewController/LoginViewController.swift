//
//  LoginViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/31/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON

var oauthSwift: OAuth2Swift?

class LoginViewController : UIViewController {
    
    // MARK: - Variables
    fileprivate let resourcePath = ResourcePathManager()
    
    fileprivate let soundService = FreesoundService()
    
//    var oauthSwift: OAuth2Swift?
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
//        oauthSwift = OAuth2Swift(consumerKey: resourcePath.clientID,
//                                 consumerSecret: resourcePath.clientSecret,
//                                 authorizeUrl: resourcePath.authorizePath,
//                                 accessTokenUrl: resourcePath.tokenPath,
//                                 responseType: "code")
        
        
        oauthSwift = soundService.oauthSwift
//        
//        if let credential = oauthSwift?.client.credential
//            where !credential.isTokenExpired() {
//            
//            performSegueWithIdentifier(SegueID.menuRootViewController, sender: self)
//            return
//        }
        
        super.viewDidLoad()
        
        setupView()
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
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        soundService.loginUser { (error) in
            if let error = error { return }
            self.performSegue(withIdentifier: SegueID.menuRootViewController, sender: self)
        }
    }
    
    @IBAction func authCodeRecieved(_ sender: UIStoryboardSegue) {
        let controller = sender.source as! AuthViewController
        
        guard let code = controller.authCode else {
            return
        }
        
        
//        oauthSwift?.startAuthorizedRequest(
//            resourcePath.tokenPath, method: .POST,
//            parameters: ["client_id": resourcePath.clientID,
//                "client_secret": resourcePath.clientSecret,
//                "grant_type": "authorization_code",
//                "code": code
//            ],
//            success: {[unowned self] (response) in
//                self.parseTokens(response.data)
//                self.performSegue(withIdentifier: SegueID.menuRootViewController, sender: self)
//            }, failure: { (error) in
//                print("Error: \(error.localizedDescription)")
//        })
    }
    
    // MARK: - Private methods
 
    fileprivate func setupView() {
        
    }

//    func parseTokens(_ data: Data) {
//        let json = JSON(data: data)
//        oauthSwift?.client.credential.oauthToken = json["access_token"].stringValue
//        oauthSwift?.client.credential.oauthRefreshToken = json["refresh_token"].stringValue
//        print("access_token = \(oauthSwift?.client.credential.oauthToken)")
//        
//        let expirationDate = Date(timeIntervalSinceNow: json["expires_in"].doubleValue)
//        oauthSwift?.client.credential.oauthTokenExpiresAt = expirationDate
//    }
//    
//    /// Removes some special characters from string
//    ///
//    /// - parameter text:    string in which remove chars
//    ///
//    /// - returns: new string without special characters
//    func removeSpecialCharsFromString(_ text: String) -> String {
//        let okayChars : Set<Character> = Set("\"".characters)
//        return String(text.characters.filter {!okayChars.contains($0) })
//    }
}

