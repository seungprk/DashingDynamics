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
        
        deathTransition(uiDelay: 1) {
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
    
    private func deathTransition(uiDelay: TimeInterval, completion: @escaping () -> Void) {
        initializeTransitionLayer()
        
        // Start first tile at a set position
        let start = CGPoint(x: scene.frame.midX - 200, y: scene.frame.midY - 150)
        
        // Delay scene for total transition duration.
        let uiDelay = SKAction.wait(forDuration: uiDelay)
        
        // Add UI after transition ends.
        scene.run(uiDelay) {
            completion()
        }
        
        // Animate tiles to cover screen.
        let rows = 50
        let cols = 10
        let delayInbetween = deathTransitionDuration / Double(rows * cols)
        
        for row in 0...rows {
            for col in 0...cols {
                let count = (row * rows) + col
                let tileDelay = Double(count) * delayInbetween
                let delay = SKAction.wait(forDuration: tileDelay)
                scene.run(delay, completion: showTile(origin: start, row: row, col: col))
            }
        }
    }
    
    /// Shows a tile by calculating position from the origin by row and col count.
    private func showTile(origin: CGPoint, row: Int, col: Int) -> () -> Void {
        let offset = CGSize(width: tileTexture.size().width * 1.5 - 4,
                            height: tileTexture.size().height / 2)
        return {
            var tilePos = CGPoint(x: origin.x + CGFloat(col) * offset.width,
                                  y: origin.y + CGFloat(row) * offset.height)
            if row.isEven() {
                tilePos.x += offset.width / 2
            }
            self.animateNewTile(position: tilePos, duration: self.tileAppearSpeed)
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
    
    private func initializeTransitionLayer() {
        transitionLayer = SKNode()
        transitionLayer?.position = CGPoint.zero
        transitionLayer?.zPosition = 1000000000
        scene.addChild(transitionLayer!)
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
