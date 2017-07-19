//
//  FreesoundService.swift
//  FreeSound
//
//  Created by chiuser on 7/4/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON

class FreesoundService {
    
    // MARK: - Variables
    
    var oauthSwift: OAuth2Swift?
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    fileprivate let resourcePath = ResourcePathManager()
    
    fileprivate var authController: AuthViewController?
    
    fileprivate let defaultSessionConfig = URLSessionConfiguration.default
    
    fileprivate var defaultSession: URLSession!
    
    // MARK: - Constructors
    
    var authHandler: ((_ error: Error?) -> Void)?
    
    init() {
        oauthSwift = OAuth2Swift(consumerKey: resourcePath.clientID,
                                 consumerSecret: resourcePath.clientSecret,
                                 authorizeUrl: resourcePath.authorizePath,
                                 accessTokenUrl: resourcePath.tokenPath,
                                 responseType: "code")
    }
    
    // MARK: - User functions
    
    func loginUser(withComplitionHandler handler: @escaping (_ error: Error?) -> Void) {
        let authController = AuthViewController()
        authController.delegate = self
        authController.oauthSwift = oauthSwift
        self.authController = authController
        
        guard let rootController = UIApplication.shared.delegate?.window??.rootViewController else  {
            handler(nil)
            return
        }
        
        self.authHandler = handler
        rootController.present(authController, animated: true, completion: nil)
    }
    
    func logoutUser(withComplitionHandler handler: @escaping (_ error: Error?) -> Void) {
        guard let url = URL(string: resourcePath.logoutPath) else {
            return
        }
        let request = NSMutableURLRequest(url: url)
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                    delegate: nil,
                                    delegateQueue: OperationQueue.main)
        
        
        let parameterString = ["client_id": resourcePath.clientID].stringFromHttpParameters()
        let requestURL = NSURL(string:"\(url)?\(parameterString)")!
        
        request.httpMethod = "GET"
        print(request)
        
        let task = defaultSession.dataTask(with: request.copy() as! URLRequest, completionHandler: {[unowned self] (data, response, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error")
                handler(nil)
                return
            }
            
            if httpResponse.statusCode == 200 {
                handler(nil)
            } else {
                print("Server Error: \(httpResponse.statusCode)")
            }
        })
        task.resume()
    }

    // MARK: - Sound functions
    
    func loadSoundWithID(_ id: Int, withComplitionHandler handler: @escaping (_ sound: SoundDetailInfo?) -> Void ) {
        
        guard let url = URL(string: resourcePath.soundPathFor("\(id)")) else {
            return
        }
        let request = URLRequest(url: url)
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                    delegate: nil,
                                    delegateQueue: OperationQueue.main)
        
        
        let task = defaultSession.dataTask(with: request, completionHandler: {[unowned self] (data, response, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    //                    if let result = self.parseSoundDetailFrom(data!) {
                    //                        handler(result)
                    //                    }
                    
                } else {
                    print("Server Error: \(httpResponse.statusCode)")
                }
            } else {
                print("Error")
            }
        })
        task.resume()
    }
    
    func downloadSound(_ soundInfo: SoundInfo, withComplitionHandler handler: @escaping (_ sound: SoundDetailInfo?) -> Void ) {
        
        guard let url = URL(string: resourcePath.soundPathFor("\(soundInfo.id)")) else {
            return
        }
        let request = URLRequest(url: url)
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                    delegate: nil,
                                    delegateQueue: OperationQueue.main)
        
        
        let task = defaultSession.dataTask(with: request, completionHandler: {[unowned self] (data, response, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    //                    if let result = self.parseSoundDetailFrom(data!) {
                    //                        handler(result)
                    //                    }
                    
                } else {
                    print("Server Error: \(httpResponse.statusCode)")
                }
            } else {
                print("Error")
            }
        })
        task.resume()
    }
    
    // MARK: - Comments functions
    
    func getCommentsFor(_ soundInfo: SoundInfo, withComplitionHandler handler: @escaping (_ sound: Any?) -> Void ) {
        
        guard let url = URL(string: resourcePath.commentsPathFor("\(soundInfo.id)")) else {
            return
        }
        let request = URLRequest(url: url)
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                    delegate: nil,
                                    delegateQueue: OperationQueue.main)
        
        
        let task = defaultSession.dataTask(with: request, completionHandler: {[unowned self] (data, response, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
//                    if let result = self.parseSoundDetailFrom(data!) {
//                        handler(result)
//                    }
                    
                } else {
                    print("Server Error: \(httpResponse.statusCode)")
                }
            } else {
                print("Error")
            }
        })
        task.resume()
    }
}

extension FreesoundService: AuthControllerdDelegate {
    func didRecieve(authCode code: String) {
        
        oauthSwift?.startAuthorizedRequest(
            resourcePath.tokenPath, method: .POST,
            parameters: ["client_id": resourcePath.clientID,
                         "client_secret": resourcePath.clientSecret,
                         "grant_type": "authorization_code",
                         "code": code
            ],
            success: {[unowned self] (response) in
                self.parseTokens(response.data)
                self.authController?.dismiss(animated: true, completion: nil)
                self.authHandler!(nil)
            }, failure: { (error) in
                print("Error: \(error.localizedDescription)")
                self.authController?.dismiss(animated: true, completion: nil)
                self.authHandler!(error)
        })
    }
    
    func parseTokens(_ data: Data) {
        let json = JSON(data: data)
        oauthSwift?.client.credential.oauthToken = json["access_token"].stringValue
        oauthSwift?.client.credential.oauthRefreshToken = json["refresh_token"].stringValue
        print("access_token = \(oauthSwift?.client.credential.oauthToken)")
        
        let expirationDate = Date(timeIntervalSinceNow: json["expires_in"].doubleValue)
        oauthSwift?.client.credential.oauthTokenExpiresAt = expirationDate
    }
    
    /// Removes some special characters from string
    ///
    /// - parameter text:    string in which remove chars
    ///
    /// - returns: new string without special characters
    func removeSpecialCharsFromString(_ text: String) -> String {
        let okayChars : Set<Character> = Set("\"".characters)
        return String(text.characters.filter {!okayChars.contains($0) })
    }
}
