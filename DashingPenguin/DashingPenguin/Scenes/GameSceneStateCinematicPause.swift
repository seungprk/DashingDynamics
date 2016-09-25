//
//  GameSceneStateCinematicPause.swift
//  DashingPenguin
//
//  Created by Seung Park on 9/25/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameSceneStateCinematicPause: GKState {
    
    unowned let scene: GameScene
    var darkOverlay: SKSpriteNode
    
    init(scene: GameScene) {
        self.scene = scene
        
        darkOverlay = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6), size: scene.size)
        darkOverlay.position = CGPoint.zero
        darkOverlay.zPosition = GameplayConfiguration.HeightOf.overlay
        
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.cameraNode?.addChild(darkOverlay)
        for childNode in scene.children {
            childNode.isPaused = true
        }
        scene.cameraNode?.isPaused = false
    }
    
    override func willExit(to nextState: GKState) {
        darkOverlay.removeFromParent()
        for childNode in scene.children {
            childNode.isPaused = false
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
}
