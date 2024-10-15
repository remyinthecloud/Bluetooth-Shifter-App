//
//  Peripherals.swift
//  BT-ShifterApp
//
//  Created by Caitlin Jacobs on 9/24/24.
//

import Foundation

struct Peripheral: Identifiable {
    
    let id: UUID
    let name: String
    let rssi: Int //used for signal strength
}
