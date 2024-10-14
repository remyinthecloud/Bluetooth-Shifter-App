//
//  BT.swift
//  BT-ShifterApp
//
//  Created by Caitlin Jacobs on 9/24/24.
//

import SwiftUI
import CoreBluetooth // Import CoreBluetooth framework for bluetooth functionalities
import Foundation

class BTManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        <#code#>
    
    }
    
    var centralManager: CBCentralManager! // Decalare a central manager variable
    @Published var isSwitchedOn = false //Declare a published variable to track if bluetooth is switched on
    @Published var peripherals = [Peripheral]() // Declare a published array to store discovered peripherals
    @Published var connectedPeripheralUUID: UUID? // Declare a published variable to store the UUID of the connected peripheral
    
    // Override the init method
    override init() {
        super.init() // Call the superclasses's intitializer
        centralManager = CBCentralManager(delegate: self, queue: nil) // Initialize the central manager with self as delegate
    }
    
    // Delegate method called when the state of the central manager is updated
    func centralManageDidUpdateState(_ central: CBCentralManager){
        isSwitchedOn = central.state == .poweredOn // Update is switched on based on the central's state
        if isSwitchedOn {
            startScanning() // Start scanning if bluetooth is turned on
        } else {
            stopScanning() // Stop scanning if bluetooth is powered off
        }
        
    }
    
    // Delegate method called when a peripheral is discovered
    func centeralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue) // Create a new peripheral object
        if !peripheral.contains(where: { $0.id == newPeripheral.id}) { // Check if the peripheral is already in the list
            
            DispatchQueue.main.async {
                self.peripherals.append(newPeripheral) // Append new peripheral to the list
            }
            
        }
    }
    
    // Function to start scanning peripherals
    func startScanning() {
        print("Starting Scanning")
        centralManager.scanForPeripherals(withServices: nil, options: nil) // Start scanning with no specific services
    }
    
    // Function to stop scanning
    func stopScanning() {
        print("Stopping Scanning")
        centralManager.stopScan() // Stop scanning
    }
    
}
