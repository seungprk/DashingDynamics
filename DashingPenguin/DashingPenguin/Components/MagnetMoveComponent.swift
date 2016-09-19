//
//  File.swift
//  DashingPenguin
//
//  Created by Seung Park on 9/18/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class MagnetMoveComponent: GKComponent {
    
    var velocityX: CGFloat
    var magnetOngoing = false
    
    init(velocityX: CGFloat) {
        self.velocityX = velocityX
        super.init()
    }
    
    func beginMagnetEffect() {
        if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {
            let origVelocity = spriteComponent.node.physicsBody?.velocity
            let newVelocity = CGVector(dx: (origVelocity?.dx)! + velocityX, dy: (origVelocity?.dy)!)
            spriteComponent.node.physicsBody?.applyImpulse(newVelocity)
            magnetOngoing = true
        }
    }
    
    override func willRemoveFromEntity() {
        if let spriteComponent = entity?.component(ofType: SpriteComponent.self) {
            let origVelocity = spriteComponent.node.physicsBody?.velocity
            let newVelocity = CGVector(dx: (origVelocity?.dx)! - velocityX, dy: (origVelocity?.dy)!)
            spriteComponent.node.physicsBody?.applyImpulse(newVelocity)
            magnetOngoing = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        print(aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
}
