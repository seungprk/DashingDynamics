//
//  GameSceneStateGameover.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/11/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneStateGameover: GKState {
    
    // Reference scene
    unowned let scene : GameScene
    
    // Re-used tile texture
    let tileTexture = SKTexture(imageNamed: "deathtile")
    
    init(scene: GameScene) {
        self.scene = scene
        super.init()
        tileTexture.filteringMode = .nearest
    }
    
    override func didEnter(from previousState: GKState?) {
        print("game over")
        // Calculate the session statistics
        /*
        guard let scoreManager = scene.scoreManager else { return }
        let totalScore    = scoreManager.getTotalScore()
        let distanceScore = scoreManager.getDistance()
        let platformScore = scoreManager.getPlatformScore()
        */
        
        deathTransition() {
            let againButton = self.makeAgainButton()
            againButton.zPosition = 1000000000 * 2
            self.scene.addChild(againButton)
        }
        
        // display the session statistics
        //   high score
        //   current score
        //   distance traveled
        //   points collected
        //     NOTE: make sure the stats are formatted, padded, and aligned properly
        // add button interaction to 
        //   exit to menu
        //   restart a new session
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStateSetup.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        transitionElapsed += seconds
    }
    
    private func makeAgainButton() -> SKButton {
        let againButton = SKButton(
            nameForImageNormal: "again-button",
            nameForImageNormalHighlight: nil
        )
        againButton.textureNormal?.filteringMode = .nearest
        againButton.name = "again_button"
        againButton.delegate = self
        againButton.zPosition = 1000000000 // TODO: set this to a reasonable zPosition based on config
        againButton.position = CGPoint(
            x: scene.frame.midX - againButton.frame.width / 2,
            y: scene.frame.midY - againButton.frame.height / 2
        )
        return againButton
    }

    // Tile Transition Methods
    let deathTransitionDuration: TimeInterval = 0.5
    let tileAppearSpeed: TimeInterval = 0.3
    var transitionLayer: SKNode?
    
    private func deathTransition(completion: @escaping () -> Void) {
        transitionElapsed = 0
        transitionLayer = SKNode()
        transitionLayer?.position = CGPoint.zero // = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        transitionLayer?.zPosition = 1000000000
        scene.addChild(transitionLayer!)
        
        // Start first tile at a set position
        let start = CGPoint(x: scene.frame.midX - 200, y: scene.frame.midY - 150)
        
        // Delay scene for total transition duration
        let uiDelay = SKAction.wait(forDuration: deathTransitionDuration)
        
        // Add UI after transition ends.
        scene.run(uiDelay) {
            completion()
        }
        
        let rows = 50
        let cols = 10
        let delayInbetween = deathTransitionDuration / Double(rows * cols)
        
        
        let dimensionNode = SKSpriteNode(texture: tileTexture)
        let tileWidth = dimensionNode.size.width
        let tileHeight = dimensionNode.size.height
        let xOffset = tileWidth * 1.5 - 4
        let yOffset = tileHeight / 2
        
        
        for row in 0...rows {
            for col in 0...cols {
                let count = (row * rows) + col
                let tileDelay = Double(count) * delayInbetween
                let delay = SKAction.wait(forDuration: tileDelay)
                scene.run(delay) {
                    var tilePos = CGPoint(x: start.x + CGFloat(col) * xOffset,
                                          y: start.y + CGFloat(row) * yOffset)
                    if row.isEven() {
                        tilePos.x += xOffset / 2
                    }
                    self.animateNewTile(position: tilePos,
                                        duration: self.tileAppearSpeed)
                }
            }
        }
    }
    
    private func animateNewTile(position: CGPoint, duration: TimeInterval) {
        guard let parent = transitionLayer else { return }
        let newTile = SKSpriteNode(texture: tileTexture)
        newTile.position = position
        newTile.scale(to: CGSize.zero)
        parent.addChild(newTile)
        let scaleToFull = SKAction.scale(to: 1, duration: duration)
        newTile.run(scaleToFull)
    }
}

extension GameSceneStateGameover: SKButtonDelegate {
    func onButtonPress(named: String) {
        guard named == "again_button" else { return }
        
        let transition = SKTransition.fade(withDuration: 1)
        if let view = self.scene.view,
            let menu = self.scene.menuScene{
            view.presentScene(menu, transition: transition)
        }
    }
}

extension Int {
    func isEven() -> Bool {
        return self % 2 == 0
    }
}
