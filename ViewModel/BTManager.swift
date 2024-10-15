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
    
    var myCentral: CBCentralManager! // Decalare a central manager variable
    @Published var isSwitchedOn = false //Declare a published variable to track if bluetooth is switched on
    @Published var peripherals = [Peripheral]() // Declare a published array to store discovered peripherals
    @Published var connectedPeripheralUUID: UUID? // Declare a published variable to store the UUID of the connected peripheral
    
    // Override the init method
    override init() {
        super.init() // Call the superclasses's intitializer
        myCentral = CBCentralManager(delegate: self, queue: nil) // Initialize the central manager with self as delegate
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
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown", rssi: RSSI.intValue) // Create a new peripheral object
        if !peripherals.contains(where: { $0.id == newPeripheral.id}) { // Check if the peripheral is already in the list
            
            DispatchQueue.main.async {
                self.peripherals.append(newPeripheral) // Append new peripheral to the list
            }
            
        }
    }
    
    // Function to start scanning peripherals
    func startScanning() {
        print("Starting Scanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil) // Start scanning with no specific services
    }
    
    // Function to stop scanning
    func stopScanning() {
        print("Stopping Scanning")
        myCentral.stopScan() // Stop scanning
    }
    
    // Function to connect to a peripheral
    func connect(to peripheral: Peripheral) {
        guard let cbPeripheral = myCentral.retrievePeripherals(withIdentifiers:[peripheral.id]).first
        else { // Retrieve peripheral by the identifier
            print("Peripheral not found for connection")
            return // Return if peripheral is not found
        }
        
        connectedPeripheralUUID = cbPeripheral.identifier // Set the connected peripheral's UUID
        cbPeripheral.delegate = self // Set self as the delegate of the peripheral
        myCentral.connect(cbPeripheral, options: nil) // Connect to the peripheral
        
        
    }
    
    // Delegate method called when a peripheral is connected
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown Peripheral")")
        peripheral.discoverServices(nil) // Discover services on the connected peripheral
    }
    
    // Delegate method called when a peripheral fails to connect
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown Peripheral")")
    }
    
    // Delegate method called when a peripheral disconnects
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown Peripheral")")
        if peripheral.identifier == connectedPeripheralUUID { // Check if the disconnected peripheral is the connected one
            connectedPeripheralUUID = nil // Clear the connected peripheral UUID
        }
    }
    
    // Delegate method called when services are discovered on a peripheral
    func peripheralDidUpdateName(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services { // Check if services are discovered
            for service in services { // Iterate through the services
                print("Discovered service: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service) // Discover characteristics for the service
                }
            }
        }
    
    // Delegate method when characteristics are discovered for a service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics { // Check if characteristics are discovered
            for characteristic in characteristics { // Iterate through the characteristics
                print("Discovered characteristic: \(characteristic.uuid)") // Print UUID
                // Interact with characteristics as needed
            }
        }
    }
}
