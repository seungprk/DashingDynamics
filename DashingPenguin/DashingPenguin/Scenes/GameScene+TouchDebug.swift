//
//  GameScene+TouchDebug.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    // MARK: - Touch functions
    
    func touchMoved(toPoint pos : CGPoint) {
        let n = SKShapeNode(circleOfRadius: 10)
        n.position = pos
        n.strokeColor = SKColor.red()
        self.addChild(n)
    }
}
