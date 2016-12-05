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
            print("initialized wall")
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
        let wallTexture = SKTexture(imageNamed: "wall")
        let wallHeight = Int(wallTexture.size().height)
        let numberOfWalls = (Int(size.height) / wallHeight) + 1
        for index in 0..<numberOfWalls {
            let newWallRight = ObstacleSideWall(size: CGSize(width: GameplayConfiguration.Sidewall.width, height: CGFloat(wallHeight)), texture: wallTexture)
            let newWallLeft = ObstacleSideWall(size: CGSize(width: GameplayConfiguration.Sidewall.width, height: CGFloat(wallHeight)), texture: wallTexture)
            
            // TODO: Clean this ugly code >.<
            if let nodeRight = newWallRight.component(ofType: SpriteComponent.self)?.node,
                let platform = firstPlatform.component(ofType: SpriteComponent.self)?.node,
                let nodeLeft = newWallLeft.component(ofType: SpriteComponent.self)?.node {
                
                let xPos = size.width / 2 - GameplayConfiguration.Sidewall.width / 2
                let position = CGPoint(x: xPos, y: begYPos + platform.position.y + CGFloat(wallHeight * index))

                nodeRight.position = position
                nodeRight.xScale = -1
                
                nodeLeft.position = CGPoint(x: -size.width / 2 + GameplayConfiguration.Sidewall.width / 2, y: position.y)
                nodeLeft.physicsBody = nil
                nodeRight.physicsBody = nil
                
                scene.addChild(nodeRight)
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
