//
//  WebViewCacheViewController.swift
//  CoreDataSample
//
//  Created by Anup kumar sahu on 12/02/24.
//  Copyright © 2024 Anup.Sahu. All rights reserved.
//

import UIKit
import WebKit

class WebViewCacheViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a WKWebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        // Load a web archive
        loadWebArchive()
    }
    
    func loadWebArchive() {
        // Assume you have a web archive file named "example.webarchive" in your app bundle
        if let webArchiveURL = Bundle.main.url(forResource: "example", withExtension: "webarchive") {
            // Create a request with the file URL
            let request = URLRequest(url: webArchiveURL)
            webView.load(request)
        } else {
            print("Web archive file not found in the app bundle.")
        }
    }
    
    // WKNavigationDelegate method to handle navigation completion
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Web page loaded successfully.")
    }
}
