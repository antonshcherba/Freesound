//
//  FreesoundService.swift
//  FreeSound
//
//  Created by Anton Shcherba on 7/4/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON
import CoreData

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
    
    func downloadSound(_ soundInfo: SoundInfo, withComplitionHandler handler: @escaping (_ sound: Data?) -> Void ) {
        let request = RequestBuilder.create(request: DownloadSoundRequest(id: "\(soundInfo.id)"))
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                    delegate: nil,
                                    delegateQueue: OperationQueue.main)
        
        
        let task = defaultSession.downloadTask(with: request) { (url, response, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)")
                handler(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let url = url {
                let data = try? Data(contentsOf: url)
                handler(data)
            } else {
                handler(nil)
            }
        }
        
        task.resume()
    }
    
    // MARK: - Comments functions
    
    func getCommentsFor(_ soundInfo: SoundInfo, withComplitionHandler handler: @escaping (_ sound: [CommentCoreData]) -> Void ) {

        let request = RequestBuilder.create(request: SoundCommentsRequest(id: Int(soundInfo.id)))
        
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
                    if let result = self.parseCommentSearchResultFrom(data!) {
                        handler(result.results as! [CommentCoreData])
                    }
                    
                } else {
                    print("Server Error: \(httpResponse.statusCode)")
                }
            } else {
                print("Error")
            }
        })	
        task.resume()
    }
    
    // MARK: - Parser
    
    // MARK: - Parse SearchResult
    func parseCommentSearchResultFrom(_ data: Data, loadedCount: Int = 0) -> SearchResult? {
        let searchJSONResult = try! JSON(data: data)
        let tmp = String(data: data, encoding: String.Encoding.utf8)
        
        guard let searchResult = SearchResult(fromJSON: searchJSONResult) else { return nil }
        if searchResult.count > 0 ||
            searchResult.count > loadedCount {
            
            searchResult.results = parseCommetnsFrom(data)
        }
        
        return searchResult
    }
    
    // MARK: - Parse Comments
    
    func parseCommetnsFrom(_ data: Data) -> [CommentCoreData] {
        let json = try! JSON(data: data)
        var jsonResultsArray = json["results"].array
        var results = [CommentCoreData]()
        
        let database = DatabaseManager()
        
//        for (index, subJSON) in jsonResultsArray!.enumerated().reversed() {
//            let request = NSFetchRequest<Comment>(entityName: Comment.entityName)
////            request.predicate = NSPredicate(format: "id == %ld", subJSON["id"].intValue)
//            
//            do {
//                let results = try database.coreData.context.fetch(request) as! [Comment]
//                //                if results.first != nil { jsonResultsArray?.remove(at: index) }
//                
//            } catch {
//                fatalError("Error loading sound info: \(error)")
//            }
//        }
        
        
        for subJSON in jsonResultsArray! {
            let comment = database.newComment
            comment.configureWithJson(subJSON)
            
            results.append(comment)
            
            do {
                try comment.managedObjectContext?.save()
            } catch {
                fatalError("Error saving songs")
            }
            
            //            print(soundInfo.tags?.count)
        }
        
        return results
    }
    
    func parseSoundDetailFrom(_ data: Data) -> SoundDetailInfo? {
        let soundDetailJSON = try! JSON(data: data)
        
        let database = DatabaseManager()
        let detailInfo = database.newSoundDetailInfo
        detailInfo.configureWithJson(soundDetailJSON)
        
        return detailInfo
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
        let json = try! JSON(data: data)
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
