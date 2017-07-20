//
//  AuthViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 6/23/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import WebKit
import OAuthSwift

protocol AuthControllerdDelegate: class  {
    func didRecieve(authCode code: String)
}

class AuthViewController : UIViewController {
    
    // MARK: - Variables
    weak var delegate: AuthControllerdDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Public Properties
    
    var authCode: String?
    
    var oauthSwift: OAuth2Swift?
    
    // MARK: - Private Properties
    
    fileprivate var webView: WKWebView!
    
    let resourcePath = ResourcePathManager()
    
    // MARK: - Constructors
    
    override func loadView() {
        super.loadView()
        
        self.webView = WKWebView()
        self.view = webView
//        containerView.addSubview(webView)
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        oauthSwift?.authorizeURLHandler = self
        oauthSwift?.authorize(withCallbackURL: URL(string: resourcePath.autorizeCallbackPath)!,
                              scope: "", state: "", success: { (credential, response, parameters) in
                                print("success")
        }, failure: { (error) in
            print(error)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    override func observeValue(forKeyPath keyPath: String?,
                                         of object: Any?,
                                                  change: [NSKeyValueChangeKey : Any]?,
                                                  context: UnsafeMutableRawPointer?) {
        
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
}

extension AuthViewController: OAuthSwiftURLHandlerType {
    func handle(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension AuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("URL: \(webView.url!)")
        print("didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        if  let query = webView.url?.query,
            let components = webView.url?.pathComponents, components.contains("permissions_granted") {
            
            webView.stopLoading()
            let code = query.replacingOccurrences(of: "code=", with: "")
            authCode = code
//            performSegue(withIdentifier: SegueID.loginViewController, sender: self)
            
            self.delegate?.didRecieve(authCode: code)
        }
        print("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommitNavigation")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinishNavigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("didFailNavigation")
    }
    
//    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
//        print("didReceiveAuthenticationChallenge")
//        
//        completionHandler(.UseCredential, nil)
//    }
    
}
