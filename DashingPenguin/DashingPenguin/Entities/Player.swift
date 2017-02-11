//
//  Player.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol LaserContactDelegate {
    func laserBodyDidContactPlayer()
}

class Player: GKEntity {
    
    var isOnPlatform = true
    var landedState: LandedState?
    var dashingState: DashingState?
    let playerAnimatedAtlas = SKTextureAtlas(named: "player")
    var idleAnimationStarted = false
    var death = ""

    
    // Sprite Atlas Initialization
    override init() {
        super.init()
        let firstTexture = playerAnimatedAtlas.textureNamed("playeridle90-1")
        let spriteComponent = SpriteComponent(texture: firstTexture)
        initPhysics(spriteComponent: spriteComponent)
    }
    
    func initPhysics(spriteComponent: SpriteComponent) {
        spriteComponent.node.size = GameplayConfiguration.Player.size
        spriteComponent.node.zPosition = 1000
        
        let physicsBody = SKPhysicsBody(circleOfRadius: GameplayConfiguration.Player.physicsBodyRadius, center: GameplayConfiguration.Player.physicsBodyOffset)
        physicsBody.categoryBitMask = GameplayConfiguration.PhysicsBitmask.player
        physicsBody.collisionBitMask   = GameplayConfiguration.PhysicsBitmask.obstacle
        physicsBody.contactTestBitMask = GameplayConfiguration.PhysicsBitmask.platform
        physicsBody.fieldBitMask = GameplayConfiguration.PhysicsBitmask.field
        
        physicsBody.restitution = 1
        physicsBody.charge = 0.1
        physicsBody.friction = 0
        physicsBody.mass = 1
        physicsBody.linearDamping = 0
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.isDynamic = true
        
        spriteComponent.node.physicsBody = physicsBody
        addComponent(spriteComponent)
        
        landedState = LandedState(entity: self)
        dashingState = DashingState(entity: self)
        addComponent(MovementComponent(states: [ landedState!,
                                                 dashingState!,
                                                 DashEndingState(entity: self),
                                                 DeathState(entity: self) ]))
        addComponent(PhysicsComponent(physicsBody: physicsBody))
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        component(ofType: MovementComponent.self)?.update(deltaTime: seconds)
        checkAnimation()
        setZPosition()
    }
    
    func checkAnimation() {
        let currentState = component(ofType: MovementComponent.self)?.stateMachine.currentState
        if currentState is LandedState && idleAnimationStarted == false {
            let idleFrames = [playerAnimatedAtlas.textureNamed("playeridle90-1"),
                              playerAnimatedAtlas.textureNamed("playeridle90-2"),
                              playerAnimatedAtlas.textureNamed("playeridle90-3"),
                              playerAnimatedAtlas.textureNamed("playeridle90-4")]
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.4, resize: false, restore: true))
            component(ofType: SpriteComponent.self)?.node.run(idleAnimation)
            idleAnimationStarted = true
        } else if currentState is DashingState {
            component(ofType: SpriteComponent.self)?.node.removeAllActions()
            let spriteNode = (component(ofType: SpriteComponent.self)?.node)!
            let velocity = (spriteNode.physicsBody?.velocity)!
            let angle = atan2(velocity.dy, velocity.dx)
            let speed = sqrt(velocity.dy * velocity.dy + velocity.dx * velocity.dx)
            
            let texturePrefix = "playerdash"
            var textureAngleText = ""
            var textureSpeedText = ""
            
            if angle < CGFloat.pi * -(7/8) {
                textureAngleText = "180"
            } else if angle < CGFloat.pi * -(5/8) {
                textureAngleText = "225"
            } else if angle < CGFloat.pi * -(3/8) {
                textureAngleText = "270"
            } else if angle < CGFloat.pi * -(1/8) {
                textureAngleText = "315"
            } else if angle < CGFloat.pi * (1/8) {
                textureAngleText = ""
            } else if angle < CGFloat.pi * (3/8) {
                textureAngleText = "45"
            } else if angle < CGFloat.pi * (5/8) {
                textureAngleText = "90"
            } else if angle < CGFloat.pi * (7/8) {
                textureAngleText = "135"
            } else if angle <= CGFloat.pi * (8/8) {
                textureAngleText = "180"
            }
            
            if speed > 300 {
                textureSpeedText = "-3"
            } else if speed > 200 {
                textureSpeedText = "-2"
            } else {
                textureSpeedText = "-1"
            }
            
            let updateTextureName = texturePrefix + textureAngleText + textureSpeedText
            let updateTexture = playerAnimatedAtlas.textureNamed(updateTextureName)
            updateTexture.filteringMode = .nearest
            spriteNode.texture = updateTexture
            
            idleAnimationStarted = false
        }
    }
    
    func setZPosition() {
        if let spriteComp = component(ofType: SpriteComponent.self),
           let scene = spriteComp.node.scene,
           let texture = component(ofType: SpriteComponent.self)?.node.texture {
            let gameScene = scene as! GameScene
            let playerYPos = spriteComp.node.position.y - texture.size().height / 2
            
            // Get a list of relevant nodes sorted by y position
            var positionalArray = [SKNode]()
            for node in gameScene.children {
                if node is PlatformBlock {
                    for nodeChild in node.children {
                        if nodeChild.name == "platform" || nodeChild.name == "obstacle" || nodeChild.name == "tiled wall" {
                            positionalArray.append(nodeChild)
                        }
                    }
                }
            }
            positionalArray.sort(by: { gameScene.convert($0.position, from: $0.parent!).y < gameScene.convert($1.position, from: $1.parent!).y })
//            print(" *** Start Array Print *** ")
//            for tester in positionalArray {
//                print(tester.name, gameScene.convert(tester.position, from: tester.parent!), " Z: ", tester.zPosition)
//            }
            // Find the node with nearest y position
            for node in positionalArray {
                var nodeTemp = node
                if nodeTemp.name == "tiled wall" {
                    nodeTemp = node.children[0] as! SKSpriteNode
                }
                var nodeYPosCheck: CGFloat
                nodeYPosCheck = gameScene.convert(nodeTemp.position, from: nodeTemp.parent!).y
                if nodeTemp.name == "platform" {
                    nodeYPosCheck += GameplayConfiguration.Platform.size.height / 2 + 12
                }
//                print("Node Top: ", nodeYPosCheck)
//                print("Player Pos: ", playerYPos)
                
                if playerYPos < nodeYPosCheck {
                    spriteComp.node.zPosition = nodeTemp.zPosition + 0.5
//                    print("Z Node Pos: ", nodeTemp.zPosition)
//                    print("Z Player Pos: ", spriteComp.node.zPosition)
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
