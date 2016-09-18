//
//  GameSceneStateGameover.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/11/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneStateGameover: GKState {
    
    unowned let scene : GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        print("game over")
        
        let delay = SKAction.wait(forDuration: 2.0)
        
        scene.run(delay) {
            let transition = SKTransition.moveIn(with: .up, duration: 0.5)
            
            if let view = self.scene.view,
               let menu = self.scene.menuScene{
                view.presentScene(menu, transition: transition)
            }
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStateSetup.Type
    }
}
