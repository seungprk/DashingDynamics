//
//  ZoneManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol LaserIdentificationDelegate {
    func isLaserActivated(for node: SKNode) -> Bool
}

class ZoneManager: LaserIdentificationDelegate {
    
    var scene: GameScene!
    var zones = [Zone]()
    enum ZoneType {
        case NormalZone
        case ChallengeZone
    }
    var lastZoneType = ZoneType.NormalZone
    var currentZone: Zone?
    var currentZoneExited = false
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Add Normal Zone
        zones.append(ZoneNormal(scene: scene, begXPos: 0, begYPos: 0, begZPos: 0))
        let firstPlatform = zones[0].platformBlocksManager.blocks[0].entities[0] as! Platform
        let texture = SKTexture(imageNamed: "bigPlatform2")
        texture.filteringMode = .nearest
        firstPlatform.component(ofType: SpriteComponent.self)?.node.texture = texture
        firstPlatform.activated = true
    }
    
    func update(deltaTime seconds: TimeInterval) {
        checkIfZoneNeedsToBeAdded()
        checkIfZoneNeedsToBeRemoved()
        
        checkIfChallengeZoneEntered()
        checkIfChallengeZoneExited()
        
        // Update through all entities
        for zone in zones {
            for block in zone.platformBlocksManager.blocks {
                for entity in block.entities {
                    entity.update(deltaTime: seconds)
                }
            }
        }
    }
    
    func checkIfZoneNeedsToBeAdded() {
        let yPosOfPlayer = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
        let begYPosOfLastZone = zones.last?.begYPos
        if yPosOfPlayer! > begYPosOfLastZone! {
            addZone()
        }
    }
    
    func checkIfZoneNeedsToBeRemoved() {
        let yPosOfBottomOfScreen = (scene.cameraNode?.position.y)! - scene.size.height/2
        if zones.count >= 2 {
            let begYPosOfSecondZone = zones[1].begYPos
            if yPosOfBottomOfScreen >= begYPosOfSecondZone! {
                zones.first?.platformBlocksManager.removeAllBlocks()
                zones.removeFirst()
            }
        }
    }
    
    func addZone() {
        let zoneFirstXPos = (zones.last?.platformBlocksManager.begXPos)!
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!
        
        // Get Last Platform's zPosition
        var lastZoneZPos: CGFloat! = nil
        if zones.last?.platformBlocksManager.blocks.last is PlatformBlockEnergyMatter {
            lastZoneZPos = zones.last?.platformBlocksManager.blocks.last?.children.last?.zPosition
        } else {
            lastZoneZPos = zones.last?.platformBlocksManager.blocks.last?.entities.last?.component(ofType: SpriteComponent.self)?.node.zPosition
            if zones.last?.platformBlocksManager.blocks.last is PlatformBlockObstacleWall {
                lastZoneZPos = zones.last?.platformBlocksManager.blocks.last?.entities.last?.component(ofType: TiledWallSpriteComponent.self)?.node.children.first?.zPosition
            }
        }
        
        if lastZoneType == ZoneType.NormalZone {
            addRandomChallengeZone()
            lastZoneType = .ChallengeZone
        } else {
            zones.append(ZoneNormal(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos, begZPos: lastZoneZPos))
            lastZoneType = .NormalZone
        }
    }
    
    func addRandomChallengeZone() {
        let zoneFirstXPos = (zones.last?.platformBlocksManager.begXPos)!
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!
        var lastZoneZPos: CGFloat! = nil
        if zones.last?.platformBlocksManager.blocks.last is PlatformBlockEnergyMatter {
            lastZoneZPos = zones.last?.platformBlocksManager.blocks.last?.children.last?.zPosition
        } else {
            lastZoneZPos = zones.last?.platformBlocksManager.blocks.last?.entities.last?.component(ofType: SpriteComponent.self)?.node.zPosition
            if zones.last?.platformBlocksManager.blocks.last is PlatformBlockObstacleWall {
                lastZoneZPos = zones.last?.platformBlocksManager.blocks.last?.entities.last?.component(ofType: TiledWallSpriteComponent.self)?.node.children.first?.zPosition
            }
        }
        let randomize = arc4random_uniform(3)
        switch randomize {
        case 0:
            zones.append(ZoneChallengeMagnet(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos, begZPos: lastZoneZPos))
        case 1:
            zones.append(ZoneChallengeVisibility(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos, begZPos: lastZoneZPos))
        case 2:
            zones.append(ZoneChallengeLongJump(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos, begZPos: lastZoneZPos))
        default:
            break
        }
    }
    
    func checkIfChallengeZoneEntered() {
        // Get current zone and platform the player is on
        var currentPlatformSprite: SKSpriteNode!
        let playerStateMachine = scene.player?.component(ofType: MovementComponent.self)?.stateMachine
        if playerStateMachine?.currentState is LandedState {
            if let currentPlatform = playerStateMachine?.state(forClass: LandedState.self)?.currentPlatform {
                
                // Activate enter event for zone
                currentPlatformSprite = currentPlatform as! SKSpriteNode
                for zone in zones {
                    let firstPlatSprite = zone.firstPlatform.component(ofType: SpriteComponent.self)?.node
                    if firstPlatSprite == currentPlatformSprite {
                        if zone is ZoneChallengeMagnet ||
                           zone is ZoneChallengeLongJump ||
                           zone is ZoneChallengeVisibility {
                            zone.enterEvent()
                            currentZone = zone
                            break
                        }
                    }
                }
            }
        }
    }
    
    func checkIfChallengeZoneExited() {
        if currentZone != nil {
            let yPosOfPlayer = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
            let begYPosOfcurrentZone = currentZone?.begYPos
            let endYPosOfcurrentZone = begYPosOfcurrentZone! + (currentZone?.size.height)!
            if yPosOfPlayer! > endYPosOfcurrentZone {
                currentZone?.exitEvent()
            }
        }
    }
    
    func isLaserActivated(for node: SKNode) -> Bool {
        for zone in zones {
            for block in zone.platformBlocksManager.blocks {
                for entity in block.entities {
                    guard let laserEntity = entity as? Laser else { continue }
                    if laserEntity.id == node.name {
                        print("player collided with \(node.name!) and isActivated is \(laserEntity.isActivated)")
                        return laserEntity.isActivated
                    }
                }
            }
        }
        return false
    }
    
    func getMatchingZPosition(yPos: CGFloat) -> CGFloat {
        if zones.count > 1 {
            for zone in zones {
                let firstPlatSpriteYPos = zone.firstPlatform.component(ofType: SpriteComponent.self)?.node.position.y
                if yPos > firstPlatSpriteYPos! - GameplayConfiguration.Platform.size.height / 2 {
                    for block in zone.platformBlocksManager.blocks {
                        for entity in block.entities {
                            if let entitySprite = entity.component(ofType: SpriteComponent.self)?.node {
                                var netEntYPos = block.position.y + entitySprite.position.y
                                if let physicsBodyOffset = entitySprite.physicsBody?.node?.position.y {
                                    netEntYPos += physicsBodyOffset
                                }
                                if netEntYPos > yPos {
                                    print("**Player Y: ", yPos, " E Y: ", netEntYPos, " Z: ", entitySprite.zPosition)
                                    return entitySprite.zPosition
                                }
                            }
                        }
                    }
                }
            }
        }
        return 0
    }
    
}
