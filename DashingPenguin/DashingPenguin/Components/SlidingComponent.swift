//
//  SlidingComponent.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 8/17/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import GameplayKit
import SpriteKit

class SlidingComponent: GKComponent {
    
    var centerX: CGFloat
    var node: SKSpriteNode
    var magnitude: CGFloat
    
    var slidingSequence: SKAction?
    
    init(node: SKSpriteNode, centerX: CGFloat, magnitude: CGFloat) {
        self.node = node
        self.centerX = centerX
        self.magnitude = magnitude
        super.init()
        
        let slidingDuration = 3.0
        
        let magnitudeMax = centerX + magnitude / 2
        let magnitudeMin = centerX - magnitude / 2
        let slidingRight = SKAction.moveTo(x: magnitudeMax, duration: slidingDuration / 2)
        let slidingLeft = SKAction.moveTo(x: magnitudeMin, duration: slidingDuration / 2)
        slidingSequence = SKAction.sequence([slidingRight, slidingLeft])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginSliding() {
        if let sequence = slidingSequence {
            node.run(SKAction.repeatForever(sequence))
        }
    }
}

