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
    var firstPlatform: Platform! {
        didSet {
            initWall()
            print("initializing wall")
        }
    }
    var hasBeenEntered = false
    var hasBeenExited = false
    
    init(scene: GameScene, begXPos: CGFloat, begYPos: CGFloat, begZPos: CGFloat) {
        self.scene = scene
        self.begYPos = begYPos
        platformBlocksManager = PlatformBlocksManager(scene: scene, begXPos: begXPos, begYPos: begYPos, begZPos: begZPos)
    }
    
    func initSize() {
        // Set Zone Size
        let botY = (platformBlocksManager.blocks.first?.position.y)! - (platformBlocksManager.blocks.first?.size.height)!/2
        let topY = (platformBlocksManager.blocks.last?.position.y)! + (platformBlocksManager.blocks.last?.size.height)!/2
        size = CGSize(width: scene.size.width, height: topY - botY)
    }
    
    
    func initWall() {
        let wallHeight = 10
        let numberOfWalls = (Int(size.height) / wallHeight) + 1
        for index in 0..<numberOfWalls {
            let newWall = Obstacle(size: CGSize(width: 8, height: CGFloat(wallHeight)))
            let newWallLeft = Obstacle(size: CGSize(width: 8, height: CGFloat(wallHeight)))
            
            if let node = newWall.component(ofType: SpriteComponent.self)?.node,
                let platform = firstPlatform.component(ofType: SpriteComponent.self)?.node,
                let nodeLeft = newWallLeft.component(ofType: SpriteComponent.self)?.node {
                let xPos = size.width / 2
                let position = CGPoint(x: xPos, y: platform.position.y + CGFloat(wallHeight * index))
                node.position = position
                
                nodeLeft.position = CGPoint(x: -xPos, y: position.y)
                nodeLeft.physicsBody = nil
                node.physicsBody = nil
                scene.addChild(node)
                scene.addChild(nodeLeft)
            }
        }
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
