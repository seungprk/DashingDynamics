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
    
    func touchDown(atPoint pos : CGPoint) {

        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green()
            self.addChild(n)
        } else {
            // Create shape node to use during touch interaction
            let w = (self.size.width + self.size.height) * 0.05
            self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.5)
            
            if let spinnyNode = self.spinnyNode {
                spinnyNode.lineWidth = 2.5
                
                spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                                  SKAction.fadeOut(withDuration: 0.5),
                                                  SKAction.removeFromParent()]))
            }
            self.touchDown(atPoint: pos)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue()
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red()
            self.addChild(n)
        }
    }
    
}
