//
//  SoundLoader.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/5/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation
import SwiftyJSON
import OAuthSwift
import CoreData
import RxSwift
import RxCocoa

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

enum SortParameter: String {
    case relevance = "score"
    case duration = "duration_asc"
    case rating = "rating_desc"
    case downloads = "downloads_desc"
}

enum FilterParameter: String {
    case username = "username"
    case tag = "tag"
    case description = "description"
    case comment = "comment"
}

func getParamsString(params: [String: String]) -> String {
        var strings:[String] = []
        
        for (param,value) in params {
            strings.append(param+"="+value)
        }

        return strings.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
}

class SoundLoader {
    
    fileprivate let resourcePath = ResourcePathManager()
    
    fileprivate let defaultSessionConfig = URLSessionConfiguration.default
    
    fileprivate var defaultSession: URLSession!
    
    fileprivate var searchResult: SearchResult?
    
    fileprivate let oauthClient: OAuthSwiftClient
    
    init() {
        oauthClient = OAuthSwiftClient(
            consumerKey: resourcePath.clientID,
            consumerSecret: resourcePath.clientSecret)
    }
    
    func load(withComplitionHandler handler: @escaping (_ sounds: [SoundInfo]) -> Void) {
        let requestString = resourcePath.searchPathWith("")

        guard let url = URL(string: requestString) else {
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
                    if let result = self.parseSearchResultFrom(data!) {
                        handler(result.results as! [SoundInfo])
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
    
    func loadSoundWithID(_ id: Int) -> Observable<SoundDetailInfo> {
        
        guard let url = URL(string: resourcePath.soundPathFor("\(id)")) else {
            return Observable.error(SomeError.wrongData)
        }

        let request = RequestBuilder.create(request: SoundInstanceRequest(id: id))
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                      delegate: nil,
                                      delegateQueue: OperationQueue.main)
        
        
//        let task = defaultSession.dataTask(with: request, completionHandler: {[unowned self] (data, response, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                handler(.failure(error))
//                return
//            }
//
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                    if let result = self.parseSoundDetailFrom(data!) {
//                        handler(.success(result))
//                    }
//
//                    return Observable.error(SomeError.wrongData)
//                } else {
//                    print("Server Error: \(httpResponse.statusCode)")
//
//                    let error = NetworkError.responseStatusError(status: httpResponse.statusCode,
//                                                                 message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
//                    handler(.failure(error))
//                }
//            } else {
//                print("Error")
//            }
//        })
//        task.resume()
        
        return self.defaultSession.rx.response(request: request)
            .map({ (httpResponse, data) -> SoundDetailInfo in
                if httpResponse.statusCode == 200 {
                    if let soundDetailInfo = self.parseSoundDetailFrom(data) {
                        return soundDetailInfo
                    }
                    
                    throw SomeError.wrongData
                } else {
                    print("Server Error: \(httpResponse.statusCode)")
                    
                    let error = NetworkError.responseStatusError(status: httpResponse.statusCode,
                                                                 message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                    throw error
                }
        })
    }
    
    
    
    func searchSoundWith(_ text: String, loadedCount: Int = 0, handler: @escaping (_ sounds: [SoundInfo]) -> Void) {
        guard let url = URL(string: resourcePath.searchPathWith(text)) else {
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
                    if let result = self.parseSearchResultFrom(data!, loadedCount: loadedCount) {
                        handler(result.results as! [SoundInfo])
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
    
    func sounds(for user: User, loadedCount: Int = 0, handler: @escaping (_ sounds: [SoundInfo]) -> Void) {
        guard let url = URL(string: resourcePath.soundsPath(for: user)) else {
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
                    if let result = self.parseSearchResultFrom(data!, loadedCount: loadedCount) {
                        handler(result.results as! [SoundInfo])
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
    
    func searchSoundWith(_ text: String, loadedCount: Int = 0,
                          sortParameter: SortParameter?,
                          filterParameter: FilterParameter?,
                          handler: @escaping (_ sounds: [SoundInfo]) -> Void) {
        var text = text
        var params: [String: String] = [:]
        
        if let sortParameter = sortParameter {
            params["sort"] = sortParameter.rawValue
        }
        if let filterParameter = filterParameter {
            params["filter"] = filterParameter.rawValue + ":\(text)"
            text = ""
        }
        
        guard let url = URL(string: resourcePath.searchPathWith(text, queryParams: params) /*+ getParamsString(params: params)*/) else {
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
                    if let result = self.parseSearchResultFrom(data!, loadedCount: loadedCount) {
                        handler(result.results as! [SoundInfo])
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

    func loadUser(withName name: String, authRequired: Bool = false) -> Observable<User> {
        guard let url = URL(string: resourcePath.userPathFor(name)) else {
            return Observable.error(SomeError.wrongData)
        }
                
        let request = RequestBuilder.create(request: UserInstanceRequest(username: name))
        
        defaultSession = URLSession(configuration: defaultSessionConfig,
                                      delegate: nil,
                                      delegateQueue: OperationQueue.main)
        
        return self.defaultSession.rx.response(request: request)
            .map({ (httpResponse, data) -> User in
                    if httpResponse.statusCode == 200 {
                        let user = User()
                        user.configureWithJson(JSON(data: data))
                        
                        return user
                    } else {
                        print("Server Error: \(httpResponse.statusCode)")
                        
                        let error = NetworkError.responseStatusError(status: httpResponse.statusCode,
                                                                     message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                        throw error
                    }
            })
    }
    
    func parseSearchResultFrom(_ data: Data) -> SearchResult? {
        let searchJSONResult = JSON(data: data)
        let tmp = String(data: data, encoding: String.Encoding.utf8)
        
        let searchResult = SearchResult(fromJSON: searchJSONResult)
        if searchResult?.count > 0 {
            searchResult?.results = parseSearchDataFrom(data)
        }
        
        return searchResult
    }
    
    func parseSearchResultFrom(_ data: Data, loadedCount: Int) -> SearchResult? {
        let searchJSONResult = JSON(data: data)
        let tmp = String(data: data, encoding: String.Encoding.utf8)
        
        let searchResult = SearchResult(fromJSON: searchJSONResult)
        if searchResult?.count > 0 ||
            searchResult?.count > loadedCount {
            
            searchResult?.results = parseSearchDataFrom(data)
        }
        
        return searchResult
    }
    
    func parseSearchDataFrom(_ data: Data) -> [SoundInfo] {
        let json = JSON(data: data)
        var jsonResultsArray = json["results"].array
        var results = [SoundInfo]()
        
        let database = DatabaseManager()
        
        for (index, subJSON) in jsonResultsArray!.enumerated().reversed() {
            let request = NSFetchRequest<SoundInfo>(entityName: SoundInfo.entityName)
            request.predicate = NSPredicate(format: "id == %ld", subJSON["id"].intValue)
            
            do {
                let results = try database.coreData.context.fetch(request) as! [SoundInfo]
//                if results.first != nil { jsonResultsArray?.remove(at: index) }
                
            } catch {
                fatalError("Error loading sound info: \(error)")
            }
        }
        
        
        for subJSON in jsonResultsArray! {
            let soundInfo = database.newSoundInfo
            soundInfo.configureWithJson(subJSON)
            
            results.append(soundInfo)
            
            do {
                try soundInfo.managedObjectContext?.save()
            } catch {
                fatalError("Error saving songs")
            }
            
//            print(soundInfo.tags?.count)
        }
        
        return results
    }
    
    func parseSoundDetailFrom(_ data: Data) -> SoundDetailInfo? {
        let soundDetailJSON = JSON(data: data)
        
        let database = DatabaseManager()
        let detailInfo = database.newSoundDetailInfo
        detailInfo.configureWithJson(soundDetailJSON)
        
        return detailInfo
    }
    
    func stopLoading() {
        defaultSession?.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }
}
