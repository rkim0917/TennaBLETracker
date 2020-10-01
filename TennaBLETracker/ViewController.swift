//
//  ViewController.swift
//  TennaBLETracker
//
//  Created by Rich Kim on 9/18/20.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
    
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    //Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        view.backgroundColor = .lightGray
        view.addSubview(button)
        button.addTarget(self,
                         action: #selector(didTapButton),
                         for: .touchUpInside)
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /*
    @IBAction func buttonClicked(_ sender: UIButton) {
      print("Testing that button works")
    }
    */
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.center = view.center
    }
    
    @objc func didTapButton() {
        // Create and present tab bar controller
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: FirstViewController())
        let vc2 = UINavigationController(rootViewController: SecondViewController())
        let vc3 = UINavigationController(rootViewController: ThirdViewController())
        let vc4 = UINavigationController(rootViewController: FourthViewController())
        let vc5 = UINavigationController(rootViewController: FifthViewController())
        
        vc1.title = "Home"
        vc2.title = "Contact"
        vc3.title = "Help"
        vc4.title = "About"
        vc5.title = "Settings"
        
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
        
        guard let items = tabBarVC.tabBar.items else {
            return
        }
        
        let images = ["house", "bell", "person.circle", "star", "gear"]
        
        for x in 0..<items.count {
            items[x].image = UIImage(systemName: images[x])
        }
        
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            
        // We've found it so stop scan
        self.centralManager.stopScan()
            
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
            
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
            
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to the Board")
            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID,ParticlePeripheral.batteryServiceUUID]);
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([ParticlePeripheral.redLEDCharacteristicUUID,
                                                             ParticlePeripheral.greenLEDCharacteristicUUID,
                                                             ParticlePeripheral.blueLEDCharacteristicUUID], for: service)
                }
                if( service.uuid == ParticlePeripheral.batteryServiceUUID ) {
                    peripheral.discoverCharacteristics([ParticlePeripheral.batteryCharacteristicUUID], for: service)
                }
            }
        }
    }
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == ParticlePeripheral.redLEDCharacteristicUUID {
                    print("Red LED characteristic found")
                } else if characteristic.uuid == ParticlePeripheral.greenLEDCharacteristicUUID {
                    print("Green LED characteristic found")
                } else if characteristic.uuid == ParticlePeripheral.blueLEDCharacteristicUUID {
                    print("Blue LED characteristic found");
                }
            }
        }
    }


}

class FirstViewController: UIViewController, UITableViewDataSource {
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        view.backgroundColor = .lightGray
        title = "Home"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Asset: \(indexPath.row + 1) | Distance: \(Float.random(in: 0..<15))"
        return cell
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Contact"
    }
}

class ThirdViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Help"
    }
}

class FourthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "About"
    }
}

class FifthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Settings"
    }
}

