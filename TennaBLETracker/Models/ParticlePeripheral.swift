//
//  TrackerPeripheral.swift
//  TennaBLETracker
//
//  Created by Rich Kim on 9/25/20.
//

import Foundation
import UIKit
import CoreBluetooth

protocol ParticleDelegate {
    
}

class ParticlePeripheral: NSObject {
    
    /// MARK: - Particle LED services and charcteristics Identifiers
    
    public static let particleLEDServiceUUID     = CBUUID.init(string: "b4250400-fb4b-4746-b2b0-93f0e61122c6")
    public static let redLEDCharacteristicUUID   = CBUUID.init(string: "b4250401-fb4b-4746-b2b0-93f0e61122c6")
    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
    public static let blueLEDCharacteristicUUID  = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")
    
    public static let batteryServiceUUID         = CBUUID.init(string: "180f")
    public static let batteryCharacteristicUUID  = CBUUID.init(string: "2a19")
    
}
