//
//  BackgroundManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 1/14/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class BackgroundManager {
    var scene: GameScene!
    var tileMatrix = [[SKSpriteNode]]()
    var bgNode = SKNode()
    var tileSize: CGSize!
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Texture Setup
        let bgAnimatedAtlas = SKTextureAtlas(named: "background")
        var bgAnimatedTextureFrames = [SKTexture]()
        for count in 1...bgAnimatedAtlas.textureNames.count {
            let texture = bgAnimatedAtlas.textureNamed("background" + String(count))
            bgAnimatedTextureFrames.append(texture)
        }
        for texture in bgAnimatedTextureFrames {
            texture.filteringMode = .nearest
        }
        tileSize = bgAnimatedTextureFrames[0].size()
        
        // Tiles Setup
        bgNode = SKNode()
        bgNode.name = "bgNode"
        
        let bgTexture = (bgAnimatedTextureFrames.last)!
        bgTexture.filteringMode = .nearest
        let tileWidth = bgTexture.size().width
        let tileHeight = bgTexture.size().height
        let horizontalTilesNumber = Int(scene.size.width / tileWidth)
        let verticalTilesNumber = Int(scene.size.height / tileHeight) + 1
        let startingX = -scene.size.width/2 + tileWidth/2
        let startingY = scene.size.height/2 - tileHeight/2
        
        // Tiles Add to Scene
        scene.cameraNode?.addChild(bgNode)
        for vIndex in 0...verticalTilesNumber {
            var row = [SKSpriteNode]()
            for hIndex in 0...horizontalTilesNumber {
                let tile = SKSpriteNode(texture: bgTexture)
                tile.position = CGPoint(x: startingX + CGFloat(hIndex) * tileWidth, y: startingY - CGFloat(vIndex) * tileHeight)
                print("** Pos: ", tile.position)
                tile.zPosition = -100000
                bgNode.addChild(tile)
                row.append(tile)
            }
            tileMatrix.append(row)
        }
        
        // Animate Tiles
        let duration: TimeInterval = 0.01
        let linePulse = SKAction.animate(with: bgAnimatedTextureFrames, timePerFrame: duration)
        let pulseTime = TimeInterval(bgAnimatedTextureFrames.count) * duration
        
        let totalPulseTime = pulseTime * TimeInterval(tileMatrix[0].count)
        for row in tileMatrix {
            for index in 0..<row.count {
                let varWaitAction = SKAction.wait(forDuration: pulseTime * TimeInterval(index))
                let endWaitAction = SKAction.wait(forDuration: totalPulseTime - pulseTime * TimeInterval(index))
                let varSeq = SKAction.sequence([varWaitAction, linePulse, endWaitAction])
                let varLoop = SKAction.repeatForever(varSeq)
                row[index].run(varLoop)
            }
        }
    }
    
    func parallaxMove(withEndY: CGFloat) {
        let parallaxFactor: CGFloat = 0.3
        let parallaxMove = SKAction.move(to: CGPoint(x: 0, y: -withEndY * parallaxFactor), duration: 0.2)
        parallaxMove.timingMode = .easeOut
        bgNode.run(parallaxMove)
    }
    
    func update() {
        if tileMatrix.count > 0 {
            let sceneHeight = scene.size.height
            
            // Move Bottom Tiles to Fill Top as Camera Moves Up
            let topNode = (tileMatrix.first?.first)!
            let topOfTopNodeY = bgNode.position.y + topNode.position.y + tileSize.height / 2
            if topOfTopNodeY < sceneHeight / 2 {
                for tile in tileMatrix.last! {
                    tile.position.y = topNode.position.y + tileSize.height
                }
                tileMatrix.insert(tileMatrix.last!, at: 0)
                tileMatrix.removeLast()
            }
            
            // Move Top Tiles to Fill Bottom as Camera Moves Down
            let botNode = (tileMatrix.last?.first)!
            let botOfBotNodeY = bgNode.position.y + botNode.position.y - tileSize.height / 2
            if botOfBotNodeY > -sceneHeight / 2 {
                for tile in tileMatrix.first! {
                    tile.position.y = botNode.position.y - tileSize.height
                }
                tileMatrix.append(tileMatrix.first!)
                tileMatrix.removeFirst()
            }
        }
    }
}
