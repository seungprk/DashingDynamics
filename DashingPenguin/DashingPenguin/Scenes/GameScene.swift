//
//  GameScene.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/3/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, GameInputDelegate {
    
    var entities = [GKEntity]()

    var controlInputNode: TouchControlInputNode?
//    var overlay: SKNode?
    var cameraNode: SKCameraNode?
    var player: Player?
    var platformBlocksManager: PlatformBlocksManager!
    var zoneManager: ZoneManager!
    
    var lastUpdateTime: TimeInterval = 0
    internal var physicsContactCount = 0
    var platformLandingDelegate: PlatformLandingDelegate?
    var laserIdDelegate: LaserIdentificationDelegate?
    
    var stateMachine: GKStateMachine!
    
    var menuScene: MenuScene?
    
    var pauseOverlay: SKNode?
    
    // MARK: - State Machine setup
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(appWillBecomeActive), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        stateMachine = GKStateMachine(states: [ GameSceneStateSetup(scene: self),
                                                GameSceneStatePlaying(scene: self),
                                                GameSceneStatePause(scene: self),
                                                GameSceneStateGameover(scene: self) ])
        stateMachine.enter(GameSceneStateSetup.self)
        
    }
    
    // MARK: Update methods
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if let currentState = player?.component(ofType: MovementComponent.self)?.stateMachine.currentState {
            if type(of: currentState) is DeathState.Type {
                stateMachine.enter(GameSceneStateGameover.self)
            }
        }
        
        updateCurrentTime(currentTime)
        centerCamera()
    }
    
    func updateCurrentTime(_ currentTime: TimeInterval) {
        // Initialize lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }

        zoneManager.update(deltaTime: dt)
        
        self.lastUpdateTime = currentTime
        
    }
    
    func centerCamera() {
        if let playerSprite = player?.component(ofType: SpriteComponent.self)?.node {
            let move = SKAction.move(to: CGPoint(x: 0, y: playerSprite.position.y + self.size.height * 0.3), duration: 0.2)
            move.timingMode = .easeOut
            cameraNode?.run(move)
        }
    }
    
    // MARK: Control Input methods
    
    func swipeGesture(velocity: CGVector) {
        guard let currentState = stateMachine.currentState,
              let playerMovement = player?.component(ofType: MovementComponent.self) else { return }
        
        if type(of: currentState) is GameSceneStatePlaying.Type {
            playerMovement.dash(velocity)
        }
    }
    
    func tapGesture(at location: CGPoint) {

    }
    
    // MARK: Notification Center methods
    
    func appWillResignActive() {
        stateMachine.enter(GameSceneStatePause.self)
    }
    
    func appWillBecomeActive() {
    }
    
}
