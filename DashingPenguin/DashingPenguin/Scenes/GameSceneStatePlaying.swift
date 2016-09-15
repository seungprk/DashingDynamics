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
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameSceneStateGameover.Type, is GameSceneStatePause.Type:
            return true
        
        default:
            return false
        }
    }
}
