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
    
    let deathTransitionDuration: TimeInterval = 0.5
    let tileAppearSpeed: TimeInterval = 0.3
    var transitionLayer: SKNode?
    
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
        
        deathTransition(uiDelay: 1, completion: showUi())

        // display the session statistics
        //   high score
        //   current score
        //   distance traveled
        //   points collected
        //     NOTE: make sure the stats are formatted, padded, and aligned properly
        // add button interaction to 
        //   exit to menu
        //   restart a new session
        
        let delay = SKAction.wait(forDuration: 2.0)
        
        scene.run(delay) {
            AudioManager.sharedInstance.stop("music")
            AudioManager.sharedInstance.stop("creeping-death-drone")
            
            let transition = SKTransition.fade(withDuration: 1)
            if let view = self.scene.view,
               let menu = self.scene.menuScene{
                view.presentScene(menu, transition: transition)
            }
        }
    }
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStateSetup.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
    
    // MARK: Present UI.
    
    func showUi() -> () -> Void {
        return {
            let againButton = self.makeAgainButton()
            let title = SKSpriteNode(imageNamed: "gameover-title")
            let scoreTitles = SKSpriteNode(imageNamed: "score-titles")
            let scoreLine = SKSpriteNode(imageNamed: "horizontal-rule")

            title.position = CGPoint(
                x: againButton.position.x,
                y: againButton.position.y + 180
            )
            scoreTitles.position = CGPoint(
                x: againButton.position.x,
                y: againButton.position.y + 120
            )
            scoreLine.position = CGPoint(
                x: scoreTitles.position.x,
                y: scoreTitles.position.y - 5
            )
            
            var ui = [SKNode]()
            ui.append(againButton)
            ui.append(title)
            ui.append(scoreTitles)
            ui.append(scoreLine)
            
            self.setFilteringMode(of: ui as! [SKSpriteNode])
            self.updateZpos(of: ui)
            self.addToScene(of: ui)
        }
    }
    
    func setFilteringMode(of nodes: [SKSpriteNode]) {
        nodes.forEach({ node in
            node.texture?.filteringMode = .nearest
        })
    }
    
    func updateZpos(of nodes: [SKNode]) {
        nodes.forEach({ node in
            node.zPosition = 1000000000 * 2
        })
    }
    
    func addToScene(of nodes: [SKNode]) {
        nodes.forEach({ node in
            scene.addChild(node)
        })
    }
    
    private func makeAgainButton() -> SKButton {
        let againButton = SKButton(
            nameForImageNormal: "again-button",
            nameForImageNormalHighlight: nil
        )
        againButton.textureNormal?.filteringMode = .nearest
        againButton.name = "again_button"
        againButton.delegate = self
        // TODO: set this to a reasonable zPosition based on config
        againButton.zPosition = 1000000000 * 2
        againButton.position = CGPoint(
            x: scene.frame.midX - againButton.frame.width / 1.5,
            y: scene.frame.midY - againButton.frame.height / 1.5 - 20
        )
        return againButton
    }

    // MARK: Tile Transition Methods
    
    private func deathTransition(uiDelay: TimeInterval, completion: @escaping () -> Void) {
        initializeTransitionLayer()
        
        // Delay the scene until ready for UI elements to be added.
        let uiDelay = SKAction.wait(forDuration: uiDelay)
        scene.run(uiDelay) {
            completion()
        }
        
        // Animate tiles to cover screen.
        let start = CGPoint(x: scene.frame.midX - 200, y: scene.frame.midY - 150)
        let rows = 70
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
    
    /// Returns a function that shows tile by calculating position 
    /// from the origin by row and col count. Should be used as the completion
    /// parameter of an SKAction.
    private func showTile(origin: CGPoint, row: Int, col: Int) -> () -> Void {
        let offset = CGSize(width: tileTexture.size().width * 1.5 - 4,
                            height: tileTexture.size().height / 2)
        // Returns a closure
        return { _ in
            var tilePos = CGPoint(x: origin.x + CGFloat(col) * offset.width,
                                  y: origin.y + CGFloat(row) * offset.height)
            if row.isEven() {
                tilePos.x += offset.width / 2
            }
            self.animateNewTile(position: tilePos, duration: self.tileAppearSpeed)
        }
    }
    
    /// Animates a single tile into the scene.
    private func animateNewTile(position: CGPoint, duration: TimeInterval) {
        guard let parent = transitionLayer else { return }
        let newTile = SKSpriteNode(texture: tileTexture)
        newTile.position = position
        newTile.scale(to: CGSize.zero)
        parent.addChild(newTile)
        let scaleToFull = SKAction.scale(to: 1, duration: duration)
        newTile.run(scaleToFull)
    }
    
    /// Initializes transition layer,
    /// must be called before adding any tiles.
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
