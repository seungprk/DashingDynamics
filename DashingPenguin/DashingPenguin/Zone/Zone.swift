//
//  Zone.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/28/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Zone {
    
    var scene: GameScene!
    var size: CGSize!
    var begYPos: CGFloat!
    var platformBlocksManager: PlatformBlocksManager!
    var firstPlatform: Platform!
    var hasBeenEntered = false
    var hasBeenExited = false
    
    init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat) {
        self.scene = scene
        self.begYPos = begYPos
        platformBlocksManager = PlatformBlocksManager(scene: scene, begXPos: begXPos, begYPos: begYPos)
    }
    
    func initSize() {
        // Set Zone Size
        let botY = (platformBlocksManager.blocks.first?.position.y)! - (platformBlocksManager.blocks.first?.size.height)!/2
        let topY = (platformBlocksManager.blocks.last?.position.y)! + (platformBlocksManager.blocks.last?.size.height)!/2
        size = CGSize(width: scene.size.width, height: topY - botY)
    }
    
    func enterEvent() {
        // Function for subclass
        if hasBeenEntered == false {
            print("Empty enterEvent Function")
            hasBeenEntered = true
        }
    }
    
    func exitEvent() {
        // Function for subclass
        if hasBeenExited == false {
            print("Empty exitEvent Function")
            hasBeenExited = true
        }
    }
}
