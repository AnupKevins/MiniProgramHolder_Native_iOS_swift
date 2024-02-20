import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate {

    private var centralManager: CBCentralManager!
    var bluetoothName = ""
    var bluetoothNumber = NSNumber(integerLiteral: 0)

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on. Scanning for devices...")
            centralManager.scanForPeripherals(withServices: nil, options: nil)

        case .poweredOff:
            print("Bluetooth is powered off.")

        case .resetting:
            print("Bluetooth is resetting.")

        case .unauthorized:
            print("Bluetooth is unauthorized.")

        case .unknown:
            print("Bluetooth state is unknown.")

        case .unsupported:
            print("Bluetooth is unsupported.")

        default:
            break
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name?.isEmpty == false {
            print("Discovered Peripheral: \(peripheral.name ?? "Unknown")")
            bluetoothName = peripheral.name ?? "Unknown"
            bluetoothNumber = RSSI.intValue as NSNumber
        }
        
        // You can perform further actions with the discovered peripheral
    }
}
