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
    let slidingDuration = 3.0

    var centerX: CGFloat
    var node: SKSpriteNode
    var magnitude: CGFloat
    
    init(node: SKSpriteNode, centerX: CGFloat, magnitude: CGFloat) {
        self.node = node
        self.centerX = centerX
        self.magnitude = magnitude
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // first duration
    // = (diff of xPos and max) / (max - min) * slidingDuration / 2
    func makeFirstRight(_ min: CGFloat, _ max: CGFloat) -> SKAction {
        let diff = abs(max - self.node.position.x)
        let total = max - min
        let percent = diff / total
        let firstDuration = slidingDuration / 2 * Double(percent)
        
        return SKAction.moveTo(x: max, duration: firstDuration)
    }
    
    func makeToAndFro(_ min: CGFloat, _ max: CGFloat) -> SKAction {
        let slidingRight = SKAction.moveTo(x: max, duration: slidingDuration / 2)
        let slidingLeft = SKAction.moveTo(x: min, duration: slidingDuration / 2)
        return SKAction.sequence([slidingLeft, slidingRight])
    }
    
    func beginSliding() {
        let min = centerX - magnitude / 2
        let max = centerX + magnitude / 2
        
        node.run(SKAction.sequence([
            makeFirstRight(min, max),
            SKAction.repeatForever(makeToAndFro(min, max))
        ]))
    }
}

