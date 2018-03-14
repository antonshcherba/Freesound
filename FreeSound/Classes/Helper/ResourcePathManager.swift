//
//  ResourePathManager.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import Foundation


import Foundation

class ResourcePathManager {
    
    enum Schema: String {
        case http = "http://"
        case https = "https://"
    }
    
    enum APIv: String {
        case V2 = "apiv2"
        case V1 = "apiv1"
    }
    
    enum authType: String {
        case oauth2 = "oauth2"
        case apiAuth = "api-auth"
    }
    
//    enum api-auth
    
    enum Resource: String {
        case Search = "search"
        case Sound = "sounds"
        case User = "users"
        
        enum SearchType: String {
            case Text = "text"
            case Content = "content"
        }
    }
    
    enum SoundResource: String {
        case download = "download"
        case upload = "upload"
        case bookmark = "bookmark"
        case comments = "comments"
        case rate = "rate"
    }
    
    enum Authentication: String {
        case Code = "authorize"
        case Logout = "logout_and_authorize"
        case Logoutt = "logout"
        case Callback = ""
        case Token = "access_token"
    }
    
    struct RequestParameter {
        static let Token = "token"
        static let Query = "query"
        static let Fields = "fields"
        
    }
    
    // MARK: - Variables
    
    // MARK: - Public Properties
    
    var securedBasePath: String {
//      "http://www.freesound.org/apiv2/search/text/?query=piano"
        
        return Schema.https.rawValue +
            hostName + String.slash +
            apiv.rawValue// + String.slash
    }
    
    
    
    var authorizePath: String {
//        https://www.freesound.org/apiv2/oauth2/authorize/
        return [securedBasePath,
                oauth.rawValue,
                Authentication.Code.rawValue]
            .joined(separator: String.slash)
    }
    
    var autorizeCallbackPath: String {
        return "https://www.myfreesound.com/permissions_granted/"
    }
    
    var tokenPath: String {
//        https://www.freesound.org/apiv2/oauth2/access_token/

        return [securedBasePath,
                oauth.rawValue,
                Authentication.Token.rawValue]
            .joined(separator: String.slash)
    }
    
    var logoutPath: String {
        //        https://www.freesound.org/apiv2/api-auth/logout/
        return [securedBasePath,
                authType.oauth2.rawValue,
                Authentication.Logout.rawValue]
            .joined(separator: String.slash)
    }
    
    var clientSecret: String {
        return APIKey
    }
    
    let clientID = "1b42440e0f401650d770"
    
    public var searchPath: String {
        
        let tmp = basePath +
            Resource.Search.rawValue + String.slash +
            Resource.SearchType.Text.rawValue + String.slash
        
        return tmp
    }
    
    //    let soundRequestString = "http://www.freesound.org/apiv2/sounds"
    var soundPath: String {
        return basePath + Resource.Sound.rawValue
    }
    
    var userPath: String {
        return basePath + Resource.User.rawValue
    }
    
    // MARK: - Private Properties
    
    fileprivate var APIKey = "25758667228b06230df1e90da76b144c529b8901"
    
    fileprivate let schema = Schema.https
    
    fileprivate let hostName = "www.freesound.org"
    
    fileprivate let apiv = APIv.V2
    
    fileprivate let basePath: String
    
    fileprivate let oauth = authType.oauth2
    
    // MARK: - Constructors
    
    init() {
        
        basePath = schema.rawValue +
            hostName + String.slash +
            apiv.rawValue + String.slash
    }
    
    // MARK: - Methods of class
    class func start() {

    }
    
    // MARK: - Methods of instance
    
    func searchPathWith(_ query: String) -> String {
        let fields = ["id", "username", "name", "license", "num_downloads", "type", "tags", "geotag"]
        let fieldsString = fields.joined(separator: ",")
        
        return searchPath + String.questionMark +
            RequestParameter.Query + String.equal + query + String.and +
            RequestParameter.Fields + String.equal + fieldsString + String.and +
            
            
            tokenParameter()
    }
    
    func searchPathWith(_ query: String, queryParams: [String: String]) -> String {
        let fields = ["id", "username", "name", "license", "num_downloads", "type", "tags", "geotag"]
        let fieldsString = fields.joined(separator: ",")

        let params = (queryParams + [RequestParameter.Query: query,
                                     RequestParameter.Fields: fieldsString,
                                     RequestParameter.Token: APIKey])
            .map { key, value in key + String.equal + value }
            .joined(separator: String.and)
        
        return searchPath + String.questionMark + params
    }
    
    func soundPathFor(_ id: String) -> String {
        return [soundPath,
                id,
                String.questionMark]
            .joined(separator:String.slash) + tokenParameter()
        
//        return soundPath +
//            id + String.slash + String.questionMark +
//            tokenParameter()
    }
    
    func soundsPath(for user: User) -> String {
        return [userPath,
                user.name,
                "sounds"]
            .joined(separator:String.slash) + tokenParameter()
        
        //        return soundPath +
        //            id + String.slash + String.questionMark +
        //            tokenParameter()
    }
    
    func downloadSoundPathFor(_ id: String) -> String {
        return [soundPath,
                id,
                SoundResource.download.rawValue,
                String.questionMark]
            .joined(separator: String.slash) + tokenParameter()
    }
    
    func commentsPathFor(_ id: String) -> String {
        return [soundPath,
                id,
                SoundResource.comments.rawValue,
                String.questionMark]
            .joined(separator: String.slash) + tokenParameter()
    }
    
    func userPathFor(_ user: String) -> String {
        if user == "me" {
            return [securedBasePath, user].joined(separator:String.slash)
        }
        
        return [userPath, user].joined(separator:String.slash) +
            String.questionMark + tokenParameter()
    }
    
    // MARK: - Overrided methods
    
    // MARK: - Private methods
    
    fileprivate func tokenParameter() -> String {
        return RequestParameter.Token + String.equal + APIKey
    }
    
}

extension Dictionary {
    public static func +(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach{ result[$0] = $1 }
        return result
    }
}
