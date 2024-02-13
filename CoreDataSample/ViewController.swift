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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "Mini Program Holder"
       

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
    
    @IBAction func eventListenerGeolocationClick(_ sender: Any) {
//        let vc = EventListenerGeoLocationViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func eventListenerBluetoothClick(_ sender: Any) {
        let vc = EventListenerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
