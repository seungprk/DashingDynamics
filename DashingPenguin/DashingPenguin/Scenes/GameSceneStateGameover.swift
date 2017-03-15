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
        
        // Once we enter this scene
        // we need to animate in the shell border
        // fade the game scene to black.
        
        // Calculate the session statistics
//        guard let scoreManager = scene.scoreManager else { return }
//        let totalScore    = scoreManager.getTotalScore()
//        let distanceScore = scoreManager.getDistance()
//        let platformScore = scoreManager.getPlatformScore()

        
        deathTransition() {
            let againButton = self.makeAgainButton()
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
        transitionElapsed += seconds
    }
    
    private func makeAgainButton() -> SKButton {
        let againButton = SKButton(
            nameForImageNormal: "again-button",
            nameForImageNormalHighlight: nil
        )
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
    let deathTransitionDuration: TimeInterval = 4.0
    var transitionLayer: SKNode?
    var transitionElapsed: TimeInterval = 0
    
    private func deathTransition(completion: @escaping () -> Void) {
        transitionElapsed = 0
        transitionLayer = SKNode()
        transitionLayer?.position = CGPoint.zero // = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        transitionLayer?.zPosition = 1000000000
        scene.addChild(transitionLayer!)
        
        // Start first tile at a set position
        let pos = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        nextTile(position: pos)
        
        // Delay scene for total transition duration
        let delay = SKAction.wait(forDuration: 4)
        
        // Add UI after transition ends.
        scene.run(delay) {
            completion()
        }
        
        // set start position
        // call nextTile
        // animate death tiles
    }
    
    private func nextTile(position: CGPoint) {
        let newPosition = CGPoint(x: position.x, y: position.y + 20)// + tileTexture.height)
        animateNewTile(position: position,
                       duration: deathTransitionDuration / 2)
        let delay = SKAction.wait(forDuration: deathTransitionDuration / 2)
        scene.run(delay) {
            if self.transitionElapsed < self.deathTransitionDuration {
                self.nextTile(position: newPosition)
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
    
    private func growTile(_ tile: SKSpriteNode, completion: @escaping () -> Void) {
        tile.scale(to: CGSize.zero)
        let scaleSpeed = 4.0
        let scaleToFull = SKAction.scale(to: 1, duration: scaleSpeed)
        tile.run(scaleToFull) {
            completion()
        }
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


