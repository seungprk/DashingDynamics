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
    var defaultColor = UIColor(red: 31/255, green: 151/255, blue: 255/255, alpha: 1.0)
    
    let deathTransitionDuration: TimeInterval = 0.5
    let tileAppearSpeed: TimeInterval = 0.3
    var transitionLayer: SKNode?
    
    let numberFont = SKTextureAtlas(named: "number-font").textures()

    init(scene: GameScene) {
        self.scene = scene
        super.init()
        tileTexture.filteringMode = .nearest
    }
    
    override func didEnter(from previousState: GKState?) {
        // Set the handlers that need to fire after the death tile transition.
        let uiFunc: () -> Void = showUi()
        let audioFunc: () -> Void = stopAudio()
        let saveFunc: () -> Void = saveScore()
        
        // Execute handlers after scene transition.
        deathTransition(uiDelay: 2) {
            uiFunc()
            audioFunc()
            saveFunc()
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStateSetup.Type
    }
    
    override func update(deltaTime seconds: TimeInterval) {
    }
    
    func stopAudio() -> () -> Void {
        return {
            AudioManager.sharedInstance.stop("music")
            AudioManager.sharedInstance.stop("creeping-death-drone")
        }
    }
    
    func saveScore() -> () -> Void {
        return {
            if let score = self.scene.scoreManager {
                score.saveHighScore()
            }
        }
    }
    
    // MARK: Present UI.
    
    func showUi() -> () -> Void {
        return {
            var ui = Set<SKNode>()
            
            let againButton = self.makeAgainButton()
            let title = SKSpriteNode(imageNamed: "gameover-title")
            let scoreTitles = SKSpriteNode(imageNamed: "score-titles")
            let scoreLine = SKSpriteNode(imageNamed: "horizontal-rule")
            let highScoreTitle = SKSpriteNode(imageNamed: "high-score-blue")
            let outline = SKSpriteNode(imageNamed: "ui-outline")
            
            [ outline,
              title,
              scoreTitles,
              scoreLine,
              againButton,
              highScoreTitle ].forEach({ node in ui.insert(node) })
            
            title.position = CGPoint(
                x: againButton.position.x,
                y: againButton.position.y + 150
            )
            scoreTitles.position = CGPoint(
                x: againButton.position.x,
                y: againButton.position.y + 100
            )
            scoreLine.position = CGPoint(
                x: scoreTitles.position.x,
                y: scoreTitles.position.y - 5
            )
            highScoreTitle.position = CGPoint(
                x: againButton.position.x,
                y: againButton.position.y + 210
            )
            outline.position = CGPoint(
                x: againButton.position.x,
                y: againButton.position.y + 128
            )

            // Initialize score labels
            
            if let score = self.scene.scoreManager {
                let topRight = CGPoint(
                    x: scoreTitles.position.x + scoreTitles.size.width / 2,
                    y: scoreTitles.position.y + scoreTitles.size.height / 2)
                
                let distanceScoreLabel = SKScoreLabel(value: score.getDistanceScore())
                let platformScoreLabel = SKScoreLabel(value: score.getPlatformScore())
                let totalScoreLabel = SKScoreLabel(value: score.getTotalScore())
                ui.insert(distanceScoreLabel)
                ui.insert(platformScoreLabel)
                ui.insert(totalScoreLabel)
     
//                #if DEBUG
//                    let dot = SKSpriteNode.dot(position: topRight)
//                    scoreTitles.parent?.addChild(dot)
//                    
//                    distanceScoreLabel.setValue(to: 1234)
//                    platformScoreLabel.setValue(to: 78)
//                    totalScoreLabel.setValue(to: 99900456)
//                #endif

                distanceScoreLabel.position = CGPoint(
                    x: topRight.x - distanceScoreLabel.size.width / 2,
                    y: topRight.y - distanceScoreLabel.size.height / 2 + 1)
                platformScoreLabel.position = CGPoint(
                    x: topRight.x - platformScoreLabel.size.width / 2,
                    y: distanceScoreLabel.position.y - platformScoreLabel.size.height)
                totalScoreLabel.position = CGPoint(
                    x: topRight.x - totalScoreLabel.size.width / 2,
                    y: platformScoreLabel.position.y - totalScoreLabel.size.height - 5)
                
                /* TEMP HIGH SCORE SPRITE HERE */
                let highScoreLabel = SKScoreLabel(value: score.getHighScore())
                ui.insert(highScoreLabel)
                
                highScoreLabel.position = CGPoint(
                    x: 0,
                    y: totalScoreLabel.position.y - totalScoreLabel.size.height * 5)
                /* END OF TEMP HIGH SCORE ADDITION */
            }
            
            self.setFilteringMode(of: ui)
            self.updateZpos(of: ui, to: 10000000 * 2)
            self.addToCamera(nodes: ui)
        }
    }
    
    /// Set the filtering mode of a node collection to .nearest.
    func setFilteringMode(of nodes: Set<SKNode>) {
        nodes.forEach({ node in
            if let sprite = node as? SKSpriteNode {
                sprite.texture?.filteringMode = .nearest
            }
        })
    }
    
    /// Updates the zPositions of a collection of nodes.
    func updateZpos(of nodes: Set<SKNode>, to height: CGFloat) {
        nodes.forEach({ node in
            node.zPosition = height
        })
    }
    
    /// Add a collection nodes to the scene
    func addToCamera(nodes: Set<SKNode>) {
        nodes.forEach({ node in
            self.scene.camera?.addChild(node)
        })
    }
    
    private func makeAgainButton() -> SKButton {
        let againButton = SKButton(
            nameForImageNormal: "again-button",
            nameForImageNormalHighlight: "again-button-active"
        )
        againButton.textureNormal?.filteringMode = .nearest
        againButton.name = "again_button"
        againButton.delegate = self
        // TODO: set this to a reasonable zPosition based on config
        againButton.zPosition = 10000000 * 2
        againButton.position.y = -againButton.frame.height * 2
        return againButton
    }

    // MARK: Tile Transition Methods
    
    /// Death transition entry point. Accepts a completion block.
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
        newTile.colorBlendFactor = 1.0
        newTile.color = defaultColor
        newTile.position = position
        newTile.scale(to: CGSize.zero)
        parent.addChild(newTile)
        let scaleToFull = SKAction.scale(to: 1, duration: duration)
        newTile.run(scaleToFull)
    }
    
    /// Initializes transition layer,
    /// must be called before adding any tiles.
    private func initializeTransitionLayer() {
        guard let camera = scene.cameraNode else {
            return
        }
        transitionLayer = SKNode()
        transitionLayer?.zPosition = 10000000
        transitionLayer?.position.y = -scene.frame.height / 2 - tileTexture.size().height
        camera.addChild(transitionLayer!)
    }
}

extension GameSceneStateGameover: SKButtonDelegate {
    func onButtonPress(named: String) {
        guard named == "again_button" else { return }

        let transition = SKTransition.fade(withDuration: 1)
        if let view = self.scene.view,
            let menu = self.scene.menuScene{
            AudioManager.sharedInstance.stop("phase-death")
            view.presentScene(menu, transition: transition)
        }
    }
    
    func onButtonDown(named: String?) {
        if let againButton = self.scene.cameraNode?.childNode(withName: "again_button") as? SKButton {
            if againButton.isActive {
                AudioManager.sharedInstance.play("beep-high")
            }
        }
    }
}

// MARK: ======== Helper Extensions ========

extension Int {
    func isEven() -> Bool {
        return self % 2 == 0
    }
}
