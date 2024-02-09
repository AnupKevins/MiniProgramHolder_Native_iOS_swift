import Foundation
import UIKit
import WebKit
import CoreLocation

class EventListenerGeoLocationViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    private var popupWebView: WKWebView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        // Add a script message handler for the 'customEvent'
      //  contentController.add(self, name: "customEvent")
        contentController.add(self, name: "toggleMessageHandler")
        config.userContentController = contentController
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        //        // Load your React app's HTML file
        //        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
        //            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        //        }
        
        view.addSubview(webView)
        
        
        if let url = URL(string: "https://172.20.10.6:3000") {
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
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
}

extension EventListenerGeoLocationViewController: WKUIDelegate {
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

extension EventListenerGeoLocationViewController: WKScriptMessageHandler {
    
    // Handle messages from the web view
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "toggleMessageHandler", let body = message.body as? [String: String] {
            print("Received event from React app:", body)
            // Handle the event as needed
        }
    }
}
