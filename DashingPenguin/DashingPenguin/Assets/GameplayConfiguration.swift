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
        static let size = CGSize(width: 40, height: 50)
        static let physicsBodyOffset = CGPoint(x: 0, y: -25)
        static let physicsBodyRadius: CGFloat = 20

        static let dashDuration = 0.1
        static let dashEndDuration = 1.5
        static let maxDashes = 2
    }
    
    struct TouchControls {
        static let minDistance: CGFloat = 005
        static let maxDistance: CGFloat = 150
        static let minDuration: Double  = 0.01
        static let maxDuration: Double  = 0.5
        static let minSpeed   : Double  = 000
        static let maxSpeed   : Double  = 900
    }
    
    struct HeightOf {
        static let controlInputNode: CGFloat = 10000
    }
    
    struct NameOf {
        static let controlInputNode = "touchInputNode"
    }
    
    struct PhysicsBitmask {
        static let none: UInt32 = 0x0
        static let all : UInt32 = 0xFFFFFFFF
        
        static let player  : UInt32 = 0x1 << 0
        static let platform: UInt32 = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
    }
}
