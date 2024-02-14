import Foundation
import UIKit
import WebKit
import CoreLocation
import CoreMotion

class EventListenerViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    private var popupWebView: WKWebView?
    var bluetoothManager: BluetoothManager?
    var locationManager : LocationManager?
    var motionManager: CMMotionManager?
    var networkManager: NetworkManager?
    var accelerationXaxis: Double = 0.0
    var accelerationYaxis: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        // Add a script message handler for the 'iOS'
        contentController.add(self, name: "iOS")
        
        config.userContentController = contentController
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        view.addSubview(webView)
        
        
        if let url = URL(string: "https://172.20.10.6:3000") {
            let request = URLRequest(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.webView.load(request)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        bluetoothManager = BluetoothManager()
        locationManager = LocationManager()
        motionManager = CMMotionManager()
        networkManager = NetworkManager()
        
        // To check device motion
        self.deviceMotionHandler()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bluetoothManager = nil
        locationManager = nil
        // Stop device motion updates when the view is about to disappear
        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
        networkManager?.stopMonitoring()
        networkManager = nil
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
        print("\(error)")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust))
    }
}

extension EventListenerViewController: WKUIDelegate {
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

extension EventListenerViewController: WKScriptMessageHandler {
    
    // Handle messages from the web view
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        guard message.name == "iOS", let body = message.body as? String else { return }
        print("Received event from React app:", body)
        
        if body == "iOS_Bluetooth" {
            sendBluetoothUpdate()
            
        } else if body == "iOS_Location" {
            sendLocationUpdate()
            
        } else if body == "iOS_DeviceMotion" {
            sendDeviceMotionUpdate()
        } else if body == "iOS_Network" {
            sendNetworkUpdate()
        } else if body == "iOS_OpenCamera" {
            openCamera()
        } else if body == "iOS_OpenPhotos" {
            openPhotoGallery()
        } else if body == "iOS_Back" {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func sendBluetoothUpdate() {
        callBluetoothJavaScriptFunction()
    }
    
    func sendLocationUpdate() {
        locationManager?.startUpdatingLocation()
        callLocationJavaScriptFunction()
    }
    
    func locationCallBack(locData: String) -> String {
        return "javascript:handleLocationData('\(locData)')"
    }
    
    func bluetoothCallBack(btData: String) -> String {
        return "javascript:handleBluetoothData('\(btData)')"
    }
    
    // Function to call JavaScript from Swift
    func callBluetoothJavaScriptFunction() {
        
        guard let bluetoothManager = bluetoothManager else { return  }
        
        let javascriptFunction = bluetoothCallBack(btData: "\(bluetoothManager.bluetoothName)|\(bluetoothManager.bluetoothNumber)")
        
        webView.evaluateJavaScript(javascriptFunction) { (result, error) in
            if let error = error {
                print("Error calling JavaScript: \(error)")
            } else {
                print("JavaScript function called successfully \(result)")
            }
        }
    }
    
    func callLocationJavaScriptFunction() {
        
        guard let locationManager = locationManager,
              let latitude = locationManager.latitude,
              let longitude = locationManager.longitude else { return  }
        
        let javascriptFunction = locationCallBack(locData: "Latitude: \(latitude)|Longitude: \(longitude)")
        
        evaluateJavascript(javascriptFunction)
    }
    
    fileprivate func evaluateJavascript(_ javascriptFunction: String) {
        webView.evaluateJavaScript(javascriptFunction) { (result, error) in
            if let error = error {
                print("Error calling JavaScript: \(error)")
            } else {
                print("JavaScript function called successfully \(result)")
            }
        }
    }
}

extension EventListenerViewController: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location access granted.")
                locationManager?.startUpdatingLocation()

            case .denied:
                print("Location access denied.")

            case .notDetermined:
                print("Location access not determined.")

            case .restricted:
                print("Location access restricted.")

            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension EventListenerViewController {
    
    func deviceMotionHandler() {
        // Check if the device supports motion
        if motionManager?.isDeviceMotionAvailable == true {
                    // Set up update interval and start receiving motion updates
            motionManager?.deviceMotionUpdateInterval = 0.1 // Update interval in seconds
            motionManager?.startDeviceMotionUpdates(to: .main) { (motion, error) in
                        if let motion = motion {
                            // Access motion data
                            let attitude = motion.attitude
                            let rotationRate = motion.rotationRate
                            let gravity = motion.gravity
                            let userAcceleration = motion.userAcceleration
                            
                            self.accelerationXaxis = userAcceleration.x
                            self.accelerationYaxis = userAcceleration.y

                            // Process motion data as needed
                            print("Attitude: \(attitude)")
                            print("Rotation Rate: \(rotationRate)")
                            print("Gravity: \(gravity)")
                            print("User Acceleration: \(userAcceleration)")
                        } else if let error = error {
                            print("Error receiving motion updates: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Device motion is not available on this device.")
                }
    }
    
    func sendDeviceMotionUpdate() {
        callDeviceMotionJavaScriptFunction()
    }
    
    
    func deviceMotionCallBack(deviceMotionData: String) -> String {
        return "javascript:handleDeviceMotionData('\(deviceMotionData)')"
    }
    
    // Function to call JavaScript from Swift
    func callDeviceMotionJavaScriptFunction() {
        
        let javascriptFunction = deviceMotionCallBack(deviceMotionData: "User Acceleration X: \(accelerationXaxis)|User Acceleration Y: \(accelerationYaxis)")
        
        webView.evaluateJavaScript(javascriptFunction) { (result, error) in
            if let error = error {
                print("Error calling JavaScript: \(error)")
            } else {
                print("JavaScript function called successfully \(result)")
            }
        }
    }
}

//  For Network Info
extension EventListenerViewController {
    func sendNetworkUpdate() {
        callNetworkJavaScriptFunction()
    }
    
    
    func networkCallBack(networkData: String) -> String {
        return "javascript:handleNetworkData('\(networkData)')"
    }
    
    // Function to call JavaScript from Swift
    func callNetworkJavaScriptFunction() {
        guard let networkManager = networkManager else { return  }
        
        var javascriptFunction = ""
        
        if networkManager.ssid.isEmpty == false {
            javascriptFunction = networkCallBack(
                networkData: "Network Name: \(networkManager.networkType)| Wifi SSID: \(networkManager.ssid)| Wifi BSSID: \(networkManager.bssid)"
            )
        } else {
            javascriptFunction = networkCallBack(networkData: "Network Name: \(networkManager.networkType)")
        }
        
        webView.evaluateJavaScript(javascriptFunction) { (result, error) in
            if let error = error {
                print("Error calling JavaScript: \(error)")
            } else {
                print("JavaScript function called successfully \(result)")
            }
        }
    }
}

