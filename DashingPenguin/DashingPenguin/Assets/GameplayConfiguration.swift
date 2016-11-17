//
//  GameplayConfiguration.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameplayConfiguration {
    struct Player {
        static let size = CGSize(width: 32, height: 32)
        static let physicsBodyOffset = CGPoint(x: 0, y: -5)
        static let physicsBodyRadius: CGFloat = 7

        static let dashDuration = 1.3 // 0.1
        static let dashEndDuration = 1.5
        static let maxDashes = 2
    }
    
    struct Platform {
        static let size = CGSize(width: 39, height: 28)
    }
    
    struct Obstacle {
        static let size = CGSize(width: 20, height: 20)
    }
    
    struct Sidewall {
        static let width: CGFloat = 10
    }
    
    struct EnergyMatter {
        static let size = CGSize(width: 16, height: 16)
    }
    struct TouchControls {
        static let minDistance: CGFloat = 005
        static let maxDistance: CGFloat = 60
        static let minDuration: Double  = 0.01
        static let maxDuration: Double  = 0.3
        static let minSpeed   : Double  = 000
        static let maxSpeed   : Double  = 900
    }
    
    struct HeightOf {
        static let controlInputNode: CGFloat = 100000
        static let overlay         : CGFloat =  50000
    }
    
    struct NameOf {
        static let controlInputNode = "touchInputNode"
    }
        
    struct PhysicsBitmask {
        static let none: UInt32 = 0x0
        static let all : UInt32 = 0xFFFFFFFF
        
        static let player      : UInt32 = 0x1 << 0
        static let platform    : UInt32 = 0x1 << 1
        static let obstacle    : UInt32 = 0x1 << 2
        static let laser       : UInt32 = 0x1 << 3
        static let energyMatter: UInt32 = 0x1 << 4
        //static let wall        : UInt32 = 0x1 << 5
    }
}
