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
    var cameraNode: SKCameraNode?
    var player: Player?
    var platformBlocksManager: PlatformBlocksManager!
    var zoneManager: ZoneManager!
    var bgManager: BackgroundManager!
    var hudManager: HudManager!
    var scoreManager: ScoreManager!
    var creepDeathManager: CreepDeathManager!
    var sideWall: ObstacleSideWall?
    var sceneEffectNode: SKEffectNode!
    var sceneCamEffectNode: SKEffectNode!
    var magnetNode: SKFieldNode!
    
    // Physics
    var lastUpdateTime: TimeInterval = 0
    internal var physicsContactCount = 1
    
    // Delegates
    var platformLandingDelegate: PlatformLandingDelegate?
    var wallContactDelegate: WallContactDelegate?
    
    var stateMachine: GKStateMachine!
    var menuScene: MenuScene?
    var pauseOverlay: SKNode?
    
    // Utility
    var cameraFollowsPlayer = true
    
    // MARK: - State Machine setup
    
    convenience init(size: CGSize, menu: MenuScene, scaleMode: SKSceneScaleMode) {
        self.init(size: size)
        self.menuScene = menu
        self.scaleMode = scaleMode
    }
    
    override func didMove(to view: SKView) {

        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        stateMachine = GKStateMachine(states: [ GameSceneStateSetup(scene: self),
                                                GameSceneStateIntro(scene: self),
                                                GameSceneStatePlaying(scene: self),
                                                GameSceneStatePause(scene: self),
                                                GameSceneStateGameover(scene: self) ])
        stateMachine.enter(GameSceneStateSetup.self)
    }
    
    // MARK: Update methods
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if self.stateMachine.currentState is GameSceneStatePlaying {
            
            if let currentState = player?.component(ofType: MovementComponent.self)?.stateMachine.currentState {
                if type(of: currentState) is DeathState.Type {
                    stateMachine.enter(GameSceneStateGameover.self)
                }
            }
            
            updateCurrentTime(currentTime)
            if cameraFollowsPlayer == true { centerCamera() }
        }
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
        
        scoreManager.updateDistanceScore()
        creepDeathManager.update(cameraYPos: (cameraNode?.position.y)!)
        self.stateMachine.state(forClass: GameSceneStateGameover.self)?.update(deltaTime: dt)
        zoneManager.update(deltaTime: dt)
        bgManager.update(deltaTime: dt)
        sideWall?.tileSideWall()
        
        self.lastUpdateTime = currentTime
        
        print("TIME DIFF: ", dt, "/ PLAYER POS: ", player?.component(ofType: SpriteComponent.self)?.node.position)
    }
    
    func centerCamera() {
        if let playerSprite = player?.component(ofType: SpriteComponent.self)?.node {
            let endY = playerSprite.position.y + self.size.height * 0.3
            if cameraNode?.position.y != endY {
                let move = SKAction.move(to: CGPoint(x: 0, y: endY), duration: 0.2)
                move.timingMode = .easeOut
                cameraNode?.run(move)
                
                bgManager.parallaxMove(withEndY: endY)
            }
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
