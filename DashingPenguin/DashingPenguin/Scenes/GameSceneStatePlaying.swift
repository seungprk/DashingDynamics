//
//  GameSceneStatePlaying.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/11/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneStatePlaying: GKState {

    unowned let scene : GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.view?.isPaused = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameSceneStateGameover.Type:
            if let playerState = scene.player?.component(ofType: MovementComponent.self)?.stateMachine.currentState {
                if type(of: playerState) is DeathState.Type {
                    return true
                }
            }
            return false
            
        case is GameSceneStatePause.Type, is GameSceneStateCinematicPause.Type:
            return true
        
        default:
            return false
        }
    }
}
