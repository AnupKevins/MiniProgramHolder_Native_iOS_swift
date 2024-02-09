import Foundation
import UIKit
import WebKit
import CoreLocation

class EventListenerBluetoothViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    private var popupWebView: WKWebView?
    var bluetoothManager: BluetoothManager?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluetoothManager = BluetoothManager()
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        // Add a script message handler for the 'customEvent'
        //  contentController.add(self, name: "customEvent")
        contentController.add(self, name: "iOS")
        config.userContentController = contentController
        webView = WKWebView(frame: view.bounds, configuration: config)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bluetoothManager = nil
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

extension EventListenerBluetoothViewController: WKUIDelegate {
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

extension EventListenerBluetoothViewController: WKScriptMessageHandler {
    
    // Handle messages from the web view
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "iOS", let body = message.body as? String {
            print("Received event from React app:", body)
            // Handle the event as needed
            sendBluetoothUpdate()
        }
    }
    
    func sendBluetoothUpdate() {
       
        
        callJavaScriptFunction()
    }
    
    // Function to call JavaScript from Swift
        func callJavaScriptFunction() {
            
            guard let bluetoothManager = bluetoothManager else { return  }
            
            let javascriptFunction = "(function() { var evt = new CustomEvent(\"MyEventType\", {detail: \"\(bluetoothManager.bluetoothName)|\(bluetoothManager.bluetoothNumber)\"});\nwindow.dispatchEvent(evt); })();"
            
            webView.evaluateJavaScript(javascriptFunction) { (result, error) in
                if let error = error {
                    print("Error calling JavaScript: \(error)")
                } else {
                    print("JavaScript function called successfully \(result)")
                }
            }
        }
    
    // WKNavigationDelegate method to handle page loading completion
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            // Call JavaScript function after the WebView has finished loading
//            callJavaScriptFunction()
//        }
}
