//
//  NetworkViewController.swift
//  CoreDataSample
//
//  Created by Anup kumar sahu on 07/02/24.
//  Copyright © 2024 Anup.Sahu. All rights reserved.
//

import UIKit
import WebKit

class NetworkViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    private var popupWebView: WKWebView?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Create WKWebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
  
        if let url = URL(string: "https://172.20.10.6:3001") {
            let request = URLRequest(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.webView.load(request)
            }
        }
    }

    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView,
        requestMediaCapturePermissionFor
        origin: WKSecurityOrigin,initiatedByFrame
        frame: WKFrameInfo,type: WKMediaCaptureType,
        decisionHandler: @escaping (WKPermissionDecision) -> Void){
         decisionHandler(.grant)
     }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("...212...\(error)")
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust  else {
            completionHandler(.useCredential, nil)
            return
        }
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
        
    }
}

extension NetworkViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        self.popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        self.popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.popupWebView?.navigationDelegate = self
        self.popupWebView?.uiDelegate = self
        if let newWebview = popupWebView {
            view.addSubview(newWebview)
        }
        return popupWebView ?? nil
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
}



