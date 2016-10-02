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
        zones.append(ZoneNormal(scene: scene, begXPos: 0, begYPos: 0))
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
//        let yPosOfBottomOfScreen = (scene.cameraNode?.position.y)! - scene.size.height/2
//        let yPosOfTopOfFirstBlock = (blocks.first?.position.y)! + (blocks.first?.size.height)!/2
//        if yPosOfBottomOfScreen >= yPosOfTopOfFirstBlock {
//            blocks.first?.removeFromParent()
//            blocks.removeFirst()
//        }
    }
    
    func addZone() {
        let zoneFirstXPos = (zones.last?.platformBlocksManager.begXPos)!
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!
        if lastZoneType == ZoneType.NormalZone {
            zones.append(ZoneChallengeVisibility(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos))
            lastZoneType = .ChallengeZone
        } else {
            zones.append(ZoneNormal(scene: scene, begXPos: zoneFirstXPos, begYPos: lastZoneTopYPos))
            lastZoneType = .NormalZone
        }
    }
    
    func checkIfChallengeZoneEntered() {
        // Get current zone and platform the player is on
        var currentPlatformSprite: SKSpriteNode!
        let playerStateMachine = scene.player?.component(ofType: MovementComponent.self)?.stateMachine
        if playerStateMachine?.currentState is LandedState {
            if let currentPlatform = playerStateMachine?.state(forClass: LandedState.self)?.currentPlatform {
                currentPlatformSprite = currentPlatform as! SKSpriteNode
                
                // Work with the found platform
                currentPlatformSprite.color = UIColor.black
                for zone in zones {
                    let firstPlatSprite = zone.firstPlatform.component(ofType: SpriteComponent.self)?.node
                    if firstPlatSprite == currentPlatformSprite {
                        zone.enterEvent()
                        currentZone = zone
                        break
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
    
}
