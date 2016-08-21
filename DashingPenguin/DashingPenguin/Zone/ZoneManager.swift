//
//  ZoneManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class ZoneManager {
    
    var scene: GameScene!
    var zones = [Zone]()
    enum ZoneType {
        case NormalZone
        case ChallengeZone
    }
    var lastZoneType = ZoneType.NormalZone
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Add Normal Zone
        zones.append(ZoneNormal(scene: scene, begYPos: 0))
    }
    
//    func update() {
//        checkIfZoneNeedsToBeAdded()
//        //checkIfZoneNeedsToBeRemoved()
//    }
    
    func checkIfZoneNeedsToBeAdded() {
        let yPosOfPlayer = scene.player?.component(ofType: SpriteComponent.self)?.node.position.y
        let begYPosOfLastZone = zones.last?.begYPos
        if yPosOfPlayer! > begYPosOfLastZone! {
            addZone()
        }
    }
    
//    func checkIfZoneNeedsToBeRemoved() {
//        let yPosOfBottomOfScreen = (scene.cameraNode?.position.y)! - scene.size.height/2
//        let yPosOfTopOfFirstBlock = (blocks.first?.position.y)! + (blocks.first?.size.height)!/2
//        if yPosOfBottomOfScreen >= yPosOfTopOfFirstBlock {
//            blocks.first?.removeFromParent()
//            blocks.removeFirst()
//        }
//    }
    
    func addZone() {
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!
        if lastZoneType == ZoneType.NormalZone {
            zones.append(ZoneChallenge(scene: scene, begYPos: lastZoneTopYPos))
            lastZoneType = .ChallengeZone
        } else {
            zones.append(ZoneNormal(scene: scene, begYPos: lastZoneTopYPos))
            lastZoneType = .NormalZone
        }
    }
}
