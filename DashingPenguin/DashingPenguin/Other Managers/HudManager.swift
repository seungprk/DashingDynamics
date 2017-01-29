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
    var scoreNumSpriteArray = [SKSpriteNode]()
    let maxScorePlaceValue = 5
    var currentScore = 0
    
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
        hudNode.addChild(scoreNode)
        
        let numberFontWidth = numberFontTextures[0].size().width
        for count in 0..<maxScorePlaceValue {
            let newSpriteNode = SKSpriteNode(texture: numberFontTextures[0])
            newSpriteNode.position.x = 0 + CGFloat(count) * numberFontWidth
            newSpriteNode.zPosition = GameplayConfiguration.HeightOf.hud + 0.5
            scoreNode.addChild(newSpriteNode)
            scoreNumSpriteArray.append(newSpriteNode)
        }
        
        updateScoreNumber(to: 1150)
    }
    
    func updateScoreNumber(to number: Int) {
        if number != currentScore {
            currentScore = number
            
            // Break down number into an array per digit
            var digits = [Int]()
            var i = number
            while i > 0 {
                digits.insert(i % 10, at: 0)
                i /= 10
            }
            if number == 0 { digits.append(0) }
            
            // Shift scoreNode depending on how many digits in the score
            let numberFontWidth = numberFontTextures[0].size().width
            scoreNode.position.x = -CGFloat(digits.count - 1) * (numberFontWidth / 2)
            
            // Pick the correct number texture and place it in the SpriteNode
            for count in 0..<digits.count {
                let digit = digits[count]
                let numberTexture = numberFontTextures[digit]
                scoreNumSpriteArray[count].texture = numberTexture
            }
            
            // For the remaining SpriteNodes set texture to nil
            for count in digits.count..<maxScorePlaceValue {
                scoreNumSpriteArray[count].texture = nil
            }
        }
    }
}
