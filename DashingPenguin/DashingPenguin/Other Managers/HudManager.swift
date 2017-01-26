//
//  HudManager.swift
//  DashingPenguin
//
//  Created by Seung Park on 1/25/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class HudManager {
    var scene: GameScene!
    var numberFontTextures = [SKTexture]()
    var hudNode = SKNode()
    var scoreNode = SKNode()
    
    init(scene: GameScene) {
        self.scene = scene
        
        setupNonInteractive()
        setupScoreSection()
    }
    
    func setupNonInteractive() {
        
        // Setup Textures
        let scoreHudAtlas = SKTextureAtlas(named: "score-hud")
        
        let baseboxTexture = scoreHudAtlas.textureNamed("score-hud-basebox")
        baseboxTexture.filteringMode = .nearest
        
        let logoTexture = scoreHudAtlas.textureNamed("score-hud-logo")
        logoTexture.filteringMode = .nearest
        
        var leftFlourishTextures = [SKTexture]()
        for count in 1...8 {
            leftFlourishTextures.append(scoreHudAtlas.textureNamed("score-hud-leftflourish" + String(count)))
        }
        for texture in leftFlourishTextures {
            texture.filteringMode = .nearest
        }
        
        let ratingTextTexture = scoreHudAtlas.textureNamed("score-hud-ratingtext")
        ratingTextTexture.filteringMode = .nearest
        
        var rightFlourishTextures = [SKTexture]()
        for count in 1...48 {
            rightFlourishTextures.append(scoreHudAtlas.textureNamed("score-hud-rightflourish" + String(count)))
        }
        for texture in rightFlourishTextures {
            texture.filteringMode = .nearest
        }
        
        let pauseButtonTexture = scoreHudAtlas.textureNamed("score-hud-pausebutton")
        pauseButtonTexture.filteringMode = .nearest
        
        // Add sprites
        let hudFullWidth: CGFloat = 176
        hudNode.position = CGPoint(x: 0, y: scene.size.height / 2 - baseboxTexture.size().height / 2 - 2)
        
        let baseboxSpriteNode = SKSpriteNode(texture: baseboxTexture)
        baseboxSpriteNode.position = CGPoint(x: hudFullWidth / 2 - baseboxTexture.size().width / 2, y: 0)
        baseboxSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud
        
        let logoSpriteNode = SKSpriteNode(texture: logoTexture)
        logoSpriteNode.position = CGPoint(x: -hudFullWidth / 2 + logoTexture.size().width / 2, y: 0)
        logoSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud
        
        let leftFlourishSpriteNode = SKSpriteNode(texture: leftFlourishTextures[0])
        leftFlourishSpriteNode.position = CGPoint(x: logoSpriteNode.position.x + 32, y: 0)
        leftFlourishSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud
        
        let ratingTextSpriteNode = SKSpriteNode(texture: ratingTextTexture)
        ratingTextSpriteNode.name = "ratingTextSpriteNode"
        ratingTextSpriteNode.position = CGPoint(x: leftFlourishSpriteNode.position.x + 44, y: 10 - ratingTextTexture.size().height / 2)
        ratingTextSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud
        
        let rightFlourishSpriteNode = SKSpriteNode(texture: rightFlourishTextures[0])
        rightFlourishSpriteNode.position = CGPoint(x: ratingTextSpriteNode.position.x + 44, y: 0)
        rightFlourishSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud
        
        let pauseButtonSpriteNode = SKSpriteNode(texture: pauseButtonTexture)
        pauseButtonSpriteNode.position = CGPoint(x: hudFullWidth / 2 - pauseButtonTexture.size().width / 2 - 5, y: 0)
        pauseButtonSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud
        
        scene.cameraNode?.addChild(hudNode)
        hudNode.addChild(baseboxSpriteNode)
        hudNode.addChild(logoSpriteNode)
        hudNode.addChild(leftFlourishSpriteNode)
        hudNode.addChild(ratingTextSpriteNode)
        hudNode.addChild(rightFlourishSpriteNode)
        hudNode.addChild(pauseButtonSpriteNode)
        
        // Animate flourishes
        let leftFlourishAnimation = SKAction.animate(with: leftFlourishTextures, timePerFrame: 0.2)
        let leftFlourishLoop = SKAction.repeatForever(leftFlourishAnimation)
        leftFlourishSpriteNode.run(leftFlourishLoop)
        
        let rightFlourishAnimation = SKAction.animate(with: rightFlourishTextures, timePerFrame: 0.2)
        let rightFlourishLoop = SKAction.repeatForever(rightFlourishAnimation)
        rightFlourishSpriteNode.run(rightFlourishLoop)
    }
    
    func setupScoreSection() {
        
        // Texture setup
        let numberFontAtlas = SKTextureAtlas(named: "number-font")
        for count in 0..<numberFontAtlas.textureNames.count {
            numberFontTextures.append(numberFontAtlas.textureNamed("hn" + String(count)))
        }
        for texture in numberFontTextures {
            texture.filteringMode = .nearest
        }
        
        scoreNode.position.x = (hudNode.childNode(withName: "ratingTextSpriteNode")?.position.x)!
        scoreNode.position.y = -10 + numberFontTextures[0].size().height / 2
        
        updateScoreNumber(to: 0)
        
        hudNode.addChild(scoreNode)
    }
    
    func updateScoreNumber(to number: Int) {
        let temp = SKSpriteNode(texture: numberFontTextures[0])
        temp.zPosition = GameplayConfiguration.HeightOf.hud
        scoreNode.addChild(temp)
    }
    
    
}
