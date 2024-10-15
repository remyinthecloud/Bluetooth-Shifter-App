//
//  ContentView.swift
//  BT-ShifterApp
//
//  Created by Caitlin Jacobs on 9/24/24.
//

import SwiftUI
import Foundation
import CoreBluetooth

struct BluetoothDevicesView: View {
    @StateObject var btManager = BTManager()
    
    var body: some View {
        VStack(spacing:10) {
            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            
            List(btManager.peripherals) { peripheral in
                HStack {
                    Text(peripheral.name)
                    Spacer()
                    Text(String(peripheral.rssi))
                    Button(action:{
                        btManager.connect(to: peripheral)
                    }) {
                        if btManager.connectedPeripheralUUID == peripheral.uuid {
                            Text("Connected")
                                .foregroundColor(.green)
                        } else {
                            Text("Connect")
                        }
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height / 2)
            
            Spacer()
            
            Text("STATUS")
                .font(.headline)
            
            if btManager.isSwitchedOn {
                Text("Bluetooth is ON")
                    .foregroundColor(.green)
            } else {
                Text("Bluetooth is OFF")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            VStack(spacing: 25) {
                Button(action: {
                    btManager.startScanning()
                    }) {
                        Text("Start Scanning")
                    }.buttonStyle(BorderedProminentButtonStyle())
                       
                       
                Button(action: {
                    btManager.stopScanning()
                }) {
                    Text("Stop Scanning")
                }.buttonStyle(BorderedProminentButtonStyle())
                       }
                    .padding()
                       
                    Spacer()
                    
                       }
                    .onAppear {
                        if btManager.isSwitchedOn {
                            btManager.startScanning()
                        }
                    }
                       
             
        
    }
}
