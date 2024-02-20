import Foundation
import UIKit
import WebKit
import CoreLocation

class GeoLocationViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    private var popupWebView: WKWebView?

    //var bluetoothManager: BluetoothManager!
  //  var locationManager: LocationManager!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Create WKWebView
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
        //locationManager = LocationManager()

       // bluetoothManager = BluetoothManager()
      //  openCamera()
        // Load URL172.20.10.6
       
        if let url = URL(string: "https://172.20.10.6:3000") {
            let request = URLRequest(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.webView.load(request)
            }
        }
        

//        if let url = URL(string: "https://172.20.10.6:3000") {
//            UIApplication.shared.open(url)
//        }
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

extension GeoLocationViewController: WKUIDelegate {
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


//extension GeoLocationViewController: CLLocationManagerDelegate {
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if #available(iOS 14.0, *) {
//            switch manager.authorizationStatus {
//            case .authorizedWhenInUse, .authorizedAlways:
//                print("Location access granted.")
//                locationManager.startUpdatingLocation()
//
//            case .denied:
//                print("Location access denied.")
//
//            case .notDetermined:
//                print("Location access not determined.")
//
//            case .restricted:
//                print("Location access restricted.")
//
//            default:
//                break
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//}
