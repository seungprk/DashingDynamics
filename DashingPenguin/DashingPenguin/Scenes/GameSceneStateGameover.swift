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
        
        // Once we enter this scene
        // we need to animate in the shell border
        // fade the game scene to black.
        
        // calculate the session statistics
        guard let scoreManager = scene.scoreManager else { return }
        let totalScore    = scoreManager.getTotalScore()
        let distanceScore = scoreManager.getDistance()
        let platformScore = scoreManager.getPlatformScore()

        // display the session statistics
        //   high score
        //   current score
        //   distance traveled
        //   points collected
        //     NOTE: make sure the stats are formatted, padded, and aligned properly
        // add button interaction to 
        //   exit to menu
        //   restart a new session
        
        let delay = SKAction.wait(forDuration: 2.0)
        
        scene.run(delay) {
            AudioManager.sharedInstance.stop("music")
            AudioManager.sharedInstance.stop("creeping-death-drone")
            
            let transition = SKTransition.fade(withDuration: 1)
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
