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
        if hasBeenEntered == false {
            
            // Setup Textures
            let challengeOverlayAtlas = SKTextureAtlas(named: "hazard-warning")
            let hazardOctagonTexture = challengeOverlayAtlas.textureNamed("hazard-warning-octagon")
            let hazardTextbarTextureFrames = [challengeOverlayAtlas.textureNamed("hazard-warning-textbar1"),
                                              challengeOverlayAtlas.textureNamed("hazard-warning-textbar2"),
                                              challengeOverlayAtlas.textureNamed("hazard-warning-textbar3"),
                                              challengeOverlayAtlas.textureNamed("hazard-warning-textbar4")]
            hazardOctagonTexture.filteringMode = .nearest
            for texture in hazardTextbarTextureFrames {
                texture.filteringMode = .nearest
            }
            
            // Setup Graphic Nodes 106width 24height full size
            let overlayFullWidth: CGFloat = 106
            let graphicYPos:CGFloat = scene.size.height * 0.30
            
            let challengeOverlayNode = SKNode()
            challengeOverlayNode.name = "challengeOverlayNode"
            
            let hazardOctagon = SKSpriteNode(texture: hazardOctagonTexture)
            hazardOctagon.name = "hazardOctagon"
            hazardOctagon.position = CGPoint(x: -(overlayFullWidth / 2) + hazardOctagonTexture.size().width / 2, y: graphicYPos)
            hazardOctagon.zPosition = 1000
            hazardOctagon.setScale(0.1)
            
            let hazardTextbar = SKSpriteNode(texture: hazardTextbarTextureFrames[0])
            hazardTextbar.name = "hazardTextbar"
            hazardTextbar.position = CGPoint(x: -hazardTextbarTextureFrames[0].size().width, y: 0)
            hazardTextbar.zPosition = 1000
            
            let maskNode = SKSpriteNode(texture: hazardTextbarTextureFrames[0])
            
            let hazardTextbarCropNode = SKCropNode()
            hazardTextbarCropNode.name = "hazardTextbarCropNode"
            hazardTextbarCropNode.maskNode = maskNode
            hazardTextbarCropNode.position = CGPoint(x: overlayFullWidth / 2 - hazardTextbarTextureFrames[0].size().width / 2, y: graphicYPos)
            
            scene.sceneCamEffectNode.addChild(challengeOverlayNode)
            challengeOverlayNode.addChild(hazardOctagon)
            challengeOverlayNode.addChild(hazardTextbarCropNode)
            hazardTextbarCropNode.addChild(hazardTextbar)
            
            // Setup and Run SKAction
            let scaleOctagon = SKAction.scale(to: 1.0, duration: 0.1)
            let slideTextbar = SKAction.moveBy(x: hazardTextbarTextureFrames[0].size().width, y: 0, duration: 0.1)
            let barAnimate = SKAction.animate(with: hazardTextbarTextureFrames, timePerFrame: 0.2)
            let barLoop = SKAction.repeatForever(barAnimate)
            
            hazardOctagon.run(scaleOctagon, completion: {
                hazardTextbar.run(slideTextbar)
                hazardTextbar.run(barLoop)
            })
            
            // Tint Background
            scene.bgManager.tint(color: UIColor.red)
        }
    }
    
    func exitEvent() {
        if hasBeenExited == false {
            let overlayNode = scene.sceneCamEffectNode.childNode(withName: "challengeOverlayNode")
            let hazardTextbarCropNode = overlayNode?.childNode(withName: "hazardTextbarCropNode") as! SKCropNode
            let hazardTextBar = hazardTextbarCropNode.childNode(withName: "hazardTextbar") as! SKSpriteNode
            let hazardOctagon = overlayNode?.childNode(withName: "hazardOctagon")
            
            // Setup and Run SKAction
            let slideInTextbar = SKAction.moveBy(x: -hazardTextBar.size.width, y: 0, duration: 0.1)
            let shrinkOctagon = SKAction.scale(to: 0.1, duration: 0.1)
            
            hazardTextBar.run(slideInTextbar, completion: {
                hazardOctagon?.run(shrinkOctagon, completion: {
                    self.scene.cameraNode?.childNode(withName: "challengeOverlayNode")?.removeFromParent()
                })
            })
            
            // Undo Background Tint
            scene.bgManager.resetTint()
        }
    }
}
