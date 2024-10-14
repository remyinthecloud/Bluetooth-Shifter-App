//
//  Peripherals.swift
//  BT-ShifterApp
//
//  Created by Caitlin Jacobs on 9/24/24.
//

import Foundation

struct Peripherals {
    let name: String
    let uuid: UUID
    let isConnected: Bool
    let isDiscoverable: Bool
    let isConnectable: Bool
    let isPaired: Bool
    let rssi: Int //used for signal strength
}
