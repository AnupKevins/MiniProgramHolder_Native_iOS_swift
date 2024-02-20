//
//  NetworkManager.swift
//  CoreDataSample
//
//  Created by Anup kumar sahu on 13/02/24.
//  Copyright © 2024 Anup.Sahu. All rights reserved.
//

import Network
// For Wifi
// Mark: In iOS, accessing detailed Wi-Fi information directly through public APIs is restricted for security and privacy reasons. However, you can obtain basic information about the current Wi-Fi network using the CNCopyCurrentNetworkInfo function from the SystemConfiguration framework.
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

class NetworkManager {

    private var pathMonitor: NWPathMonitor?
    
    var networkType: NWInterface.InterfaceType = .other
    
    var ssid = ""
    var bssid = ""
    
    var currentNetworkInfo: [String: Any] = [:]

    init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        pathMonitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        pathMonitor?.start(queue: queue)

        pathMonitor?.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Network is available")

                // Additional information about the current network
                if let interfaceType = path.availableInterfaces.first?.type {
                    self?.networkType = interfaceType
                    print("Current Network Interface Type: \(interfaceType)")
                    
                    if interfaceType == .wifi {
                        self?.getCurrentWiFiInfo()
                        
                        self?.getNetworkInfo { (wifiInfo) in
                                       
                            self?.currentNetworkInfo = wifiInfo
                            
                            print("currentNetworkInfo: \(wifiInfo)")
                           
                        }
                    }
                }
            } else {
                print("No network connection")
            }
        }
    }

    func stopMonitoring() {
        pathMonitor?.cancel()
    }
    
    func getCurrentWiFiInfo() {
        if let interfaces = CNCopySupportedInterfaces() as? [String],
           let currentInterface = interfaces.first as CFString?,
           let networkInfo = CNCopyCurrentNetworkInfo(currentInterface) as? [String: Any] {
            
            if let ssid = networkInfo[kCNNetworkInfoKeySSID as String] as? String {
                self.ssid = ssid
                print("SSID: \(ssid)")
            }
            
            if let bssid = networkInfo[kCNNetworkInfoKeyBSSID as String] as? String {
                self.bssid = bssid
                print("BSSID: \(bssid)")
            }
        }
    }
    
    func getNetworkInfo(compleationHandler: @escaping ([String: Any])->Void){
        
       var currentWirelessInfo: [String: Any] = [:]
        
        if #available(iOS 14.0, *) {
            
            NEHotspotNetwork.fetchCurrent { network in
                
                guard let network = network else {
                    compleationHandler([:])
                    return
                }
                
                let bssid = network.bssid
                let ssid = network.ssid
                currentWirelessInfo = ["BSSID ": bssid, "SSID": ssid, "SSIDDATA": "<54656e64 615f3443 38354430>"]
                compleationHandler(currentWirelessInfo)
            }
        }
        else {
            #if !TARGET_IPHONE_SIMULATOR
            guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
                compleationHandler([:])
                return
            }
            
            guard let name = interfaceNames.first, let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: Any] else {
                compleationHandler([:])
                return
            }
            
            currentWirelessInfo = info
            
            #else
            currentWirelessInfo = ["BSSID ": "c8:3a:35:4c:85:d0", "SSID": "Tenda_4C85D0", "SSIDDATA": "<54656e64 615f3443 38354430>"]
            #endif
            compleationHandler(currentWirelessInfo)
        }
    }
}

// ...

// Remember to keep a strong reference to the `NetworkMonitor` instance while you need to monitor the network.
