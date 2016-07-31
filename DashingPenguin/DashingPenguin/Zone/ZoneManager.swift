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
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Add Zone A
        zones.append(ZoneA(scene: scene, begYPos: 0))
        
        // Add Zone B
        let lastZoneTopYPos = (zones.last?.begYPos)! + (zones.last?.size.height)!
        print(zones.last?.begYPos)
        print(zones.last?.size.height)
        zones.append(ZoneB(scene: scene, begYPos: lastZoneTopYPos))
    }
//    
//    func update() {
//        checkIfBlockNeedsToBeAdded()
//        checkIfBlockNeedsToBeRemoved()
//    }
//    
//    func checkIfBlockNeedsToBeAdded() {
//        let yPosOfTopOfScreen = (scene.cameraNode?.position.y)! + scene.size.height/2
//        let yPosOfTopOfLastBlock = (blocks.last?.position.y)! + (blocks.last?.size.height)!/2
//        if yPosOfTopOfScreen >= yPosOfTopOfLastBlock {
//            addBlock()
//        }
//    }
//    
//    func checkIfBlockNeedsToBeRemoved() {
//        let yPosOfBottomOfScreen = (scene.cameraNode?.position.y)! - scene.size.height/2
//        let yPosOfTopOfFirstBlock = (blocks.first?.position.y)! + (blocks.first?.size.height)!/2
//        if yPosOfBottomOfScreen >= yPosOfTopOfFirstBlock {
//            blocks.first?.removeFromParent()
//            blocks.removeFirst()
//        }
//    }
    
}
