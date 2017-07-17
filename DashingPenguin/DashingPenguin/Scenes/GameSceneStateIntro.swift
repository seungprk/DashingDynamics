//
//  GameSceneStateIntro.swift
//  DashingPenguin
//
//  Created by Seung Park on 4/30/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneStateIntro: GKState {
    
    unowned let scene : GameScene
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.view?.isPaused = false
        
//        // Setup textures
//        let playerAtlas = (scene.player?.playerAnimatedAtlas)!
//        var playerTextureFrames = [SKTexture]()
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash90-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash135-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash180-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash225-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash270-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash315-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash45-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash45-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash90-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash90-1"))
//        playerTextureFrames.append(playerAtlas.textureNamed("playerdash90-1"))
//        for texture in playerTextureFrames {
//            texture.filteringMode = .nearest
//        }
        
        // Setup intro player animation
        let playerSpriteComp = scene.player?.component(ofType: SpriteComponent.self)
        let playerSprite = playerSpriteComp?.node
        
        playerSprite?.xScale = 2
        playerSprite?.yScale = 6
        
        let playerStartY = scene.size.height * 0.5 + (scene.cameraNode?.position.y)! + (playerSprite?.size.height)! / 2
        playerSprite?.position = CGPoint(x: 0, y: playerStartY)
        
        let playerLandPos = CGPoint(x: 0, y: GameplayConfiguration.Platform.size.height / 2)
        
        let dropAction = SKAction.move(to: playerLandPos, duration: 1)
        dropAction.timingMode = SKActionTimingMode.easeOut
        let scaleAction = SKAction.scale(to: 1.0, duration: 1)
        scaleAction.timingMode = SKActionTimingMode.easeOut
//        let spinAction = SKAction.animate(with: playerTextureFrames, timePerFrame: 0.1)
        
//        playerSprite?.run(spinAction)
        playerSprite?.run(scaleAction)
        playerSprite?.run(dropAction, completion: {
            self.stateMachine?.enter(self.getNextState())
        })
        playerSprite?.run(SKAction.wait(forDuration: 0.15), completion: {
            AudioManager.sharedInstance.play("splat")
        })
    }
    
    func getNextState() -> AnyClass {
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "isTutorialShown") != nil {
            return GameSceneStatePlaying.self
        } else {
            userDefaults.set(true, forKey: "isTutorialShown")
            return GameSceneStateTutorial.self
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type ||
            stateClass is GameSceneStateTutorial.Type
    }
}
