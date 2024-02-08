//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Anup.Sahu on 29/12/20.
//  Copyright © 2020 Anup.Sahu. All rights reserved.
//

import UIKit
import CoreLocation
import CoreLocationUI

class ViewController: UIViewController {

    class func initVC() -> ViewController {
              let storyboard = UIStoryboard(name:"Main", bundle: Bundle(for: ViewController.self))
              let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
              return vc
       }
    
  //  var locationManager: LocationManager!

    //@IBOutlet weak var imgView:UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "Mini Program Holder"
       

    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
    
//            locationManager = LocationManager()
//            locationManager.startUpdatingLocation()
    
    
        }

    @IBAction func cameraClick(_ sender: Any) {
        let vc = CameraViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

       @IBAction func bluetoothClick(_ sender: Any) {
          let vc = BluetoothViewController()
           self.navigationController?.pushViewController(vc, animated: true)
       }

       @IBAction func deviceMotion(_ sender: Any) {
           let vc = DeviceMotionViewController()
           self.navigationController?.pushViewController(vc, animated: true)
          
       }
//
       @IBAction func geolocationClick(_ sender: Any) {
           let vc = GeoLocationViewController()
           self.navigationController?.pushViewController(vc, animated: true)
           
       }

    @IBAction func networkClick(_ sender: Any) {
        let vc = NetworkViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}


//import Foundation
//import UIKit
//import WebKit
//import CoreLocation
//
//class ViewController: UIViewController, WKNavigationDelegate {
//
//    var webView: WKWebView!
//    
//    //var bluetoothManager: BluetoothManager!
//  //  var locationManager: LocationManager!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Create WKWebView
//        webView = WKWebView(frame: view.bounds)
//        webView.navigationDelegate = self
//        view.addSubview(webView)
//        
//       
//       // bluetoothManager = BluetoothManager()
//      //  openCamera()
//        // Load URL172.20.10.6
//        if let url = URL(string: "http://172.20.10.6:3000") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//        }
//        
////        if let url = URL(string: "https://172.20.10.6:3000") {
////            UIApplication.shared.open(url)
////        }
//    }
//    
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated)
////        
////        locationManager = LocationManager()
////        locationManager.startUpdatingLocation()
////        
////        
////    }
////
////    func openCamera() {
////            if UIImagePickerController.isSourceTypeAvailable(.camera) {
////                let imagePicker = UIImagePickerController()
////                imagePicker.delegate = self
////                imagePicker.sourceType = .camera
////                imagePicker.allowsEditing = false
////                present(imagePicker, animated: true, completion: nil)
////            } else {
////                print("Camera not available.")
////            }
////        }
//
////        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
////                imageView.image = pickedImage
////            }
////
////            dismiss(animated: true, completion: nil)
////        }
//
////        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
////            dismiss(animated: true, completion: nil)
////        }
//    // Optional: Implement WKNavigationDelegate methods if needed
//    
//    
//    
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        print("...212...\(error)")
//    }
//    
////    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
////            guard let serverTrust = challenge.protectionSpace.serverTrust else { return completionHandler(.useCredential, nil) }
////            let exceptions = SecTrustCopyExceptions(serverTrust)
////            SecTrustSetExceptions(serverTrust, exceptions)
////            completionHandler(.useCredential, URLCredential(trust: serverTrust))
////        }
//}
//
//extension ViewController: CLLocationManagerDelegate {
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
