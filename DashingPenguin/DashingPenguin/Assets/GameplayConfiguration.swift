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
        static let physicsBodyOffset = CGPoint(x: 0, y: -25)
    }
    
    struct TouchControls {
        static let minDistance: CGFloat = 005
        static let maxDistance: CGFloat = 300
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
}
