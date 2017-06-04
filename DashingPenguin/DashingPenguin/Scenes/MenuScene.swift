//
//  MenuScene.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/9/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

/*  TODO: Resolve SKScene memory dealloc
 *  http://stackoverflow.com/a/22528395/2684355
 */

import SpriteKit
import GameplayKit
import CoreMotion

let SoundStringOn  = "Sound On"
let SoundStringOff = "Sound Off"

class MenuScene: SKScene, SKButtonDelegate {
    
    var hasBeenPresentedOnce = false
    var scoreView: UIView?
    var scoreBox: SKSpriteNode!
    let timeScale: TimeInterval = 0.5
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .init(red: 5/255, green: 20/255, blue: 33/255, alpha: 1)
        AudioManager.sharedInstance.preInit()
        
        // Add Camera
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        camera = cameraNode
        addChild(cameraNode)
        
        // Add Shell Border
        let shellLeftTexture = SKTexture(imageNamed: "shellpiece-left")
        let shellRightTexture = SKTexture(imageNamed: "shellpiece-right")
        let shellTopTexture = SKTexture(imageNamed: "shellpiece-top")
        let shellBottomTexture = SKTexture(imageNamed: "shellpiece-bottom")
        
        shellLeftTexture.filteringMode = .nearest
        shellRightTexture.filteringMode = .nearest
        shellTopTexture.filteringMode = .nearest
        shellBottomTexture.filteringMode = .nearest
        
        let shellLeft = SKSpriteNode(texture: shellLeftTexture)
        shellLeft.position = CGPoint(x: -shellLeftTexture.size().width / 2, y: size.height / 2)
        shellLeft.zPosition = 0
        let shellRight = SKSpriteNode(texture: shellRightTexture)
        shellRight.position = CGPoint(x: size.width + shellRightTexture.size().width / 2, y: size.height / 2)
        shellRight.zPosition = 0
        let shellTop = SKSpriteNode(texture: shellTopTexture)
        shellTop.position = CGPoint(x: size.width / 2, y: size.height + shellTopTexture.size().height / 2)
        shellTop.zPosition = 1
        let shellBottom = SKSpriteNode(texture: shellBottomTexture)
        shellBottom.position = CGPoint(x: size.width / 2, y: -shellBottomTexture.size().height / 2)
        shellBottom.zPosition = 1
        
        addChild(shellLeft)
        addChild(shellRight)
        addChild(shellTop)
        addChild(shellBottom)
        
        // Add Static Graphics
        
        let border = SKSpriteNode(imageNamed: "menu-border")
        border.name = "border"
        border.texture?.filteringMode = .nearest
        border.position = CGPoint(x: frame.midX, y: frame.midY + 26)
        border.alpha = 0
        addChild(border)
        
        let title = SKSpriteNode(imageNamed: "menu-title")
        title.name = "title"
        title.texture?.filteringMode = .nearest
        title.position = CGPoint(x: frame.midX, y: frame.midY + 107)
        title.alpha = 0
        addChild(title)
        
        let box1 = SKSpriteNode(imageNamed: "menu-box1")
        box1.name = "box1"
        box1.texture?.filteringMode = .nearest
        box1.position = CGPoint(x: frame.midX, y: frame.midY + 73)
        box1.alpha = 0
        addChild(box1)
        
        let box2 = SKSpriteNode(imageNamed: "menu-box2")
        box2.name = "box2"
        box2.texture?.filteringMode = .nearest
        box2.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        box2.alpha = 0
        addChild(box2)
        
        let box3 = SKSpriteNode(imageNamed: "menu-box3")
        box3.name = "box3"
        box3.texture?.filteringMode = .nearest
        box3.position = CGPoint(x: frame.midX, y: frame.midY - 47)
        box3.alpha = 0
        addChild(box3)
        
        // Add Buttons
        
        let playButton = SKButton(nameForImageNormal: "menu-play", nameForImageNormalHighlight: "menu-play-active")
        playButton.name = "playButton"
        playButton.delegate = self
        playButton.texture?.filteringMode = .nearest
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 104)
        playButton.alpha = 0
        addChild(playButton)
        
        let scoreButton = SKButton(nameForImageNormal: "menu-score", nameForImageNormalHighlight: "menu-score-active")
        scoreButton.name = "scoreButton"
        scoreButton.delegate = self
        scoreButton.texture?.filteringMode = .nearest
        scoreButton.position = CGPoint(x: size.width / 2 + 31, y: size.height / 2 - 5)
        scoreButton.alpha = 0
        addChild(scoreButton)
        
        // Add Sound Toggle
        let soundToggle = SKToggle(isOn: AudioManager.sharedInstance.isSoundOn, imageNormal: "menu-sound", imageHighlight: "menu-sound-active", imageOff: "menu-sound-off", imageOffHighlight: "menu-sound-off-active")
        soundToggle.name = "soundToggle"
        soundToggle.delegate = self
        soundToggle.position = CGPoint(x: size.width / 2 - 31, y: size.height / 2 - 5)
        soundToggle.alpha = 0
        addChild(soundToggle)
        
        // Shell Slide In Animation
        
        let slideInDur = TimeInterval(2) * timeScale
        
        let slideInLeft = SKAction.move(to: CGPoint(x: shellLeftTexture.size().width / 1.8, y: size.height / 2 + 3), duration: slideInDur * 0.6)
        let slideInLeftBack = SKAction.move(to: CGPoint(x: shellLeftTexture.size().width / 2, y: size.height / 2 + 3), duration: slideInDur * 0.05)
        
        let slideInRight = SKAction.move(to: CGPoint(x: size.width - shellRightTexture.size().width / 1.8, y: size.height / 2 + 3), duration: slideInDur * 0.6)
        let slideInRightBack = SKAction.move(to: CGPoint(x: size.width - shellRightTexture.size().width / 2, y: size.height / 2 + 3), duration: slideInDur * 0.05)
        
        let slideInTop = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height - shellTopTexture.size().height / 1.8), duration: slideInDur)
        let slideInTopBack = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height - shellTopTexture.size().height / 2), duration: slideInDur * 0.05)

        let slideInBottom = SKAction.move(to: CGPoint(x: size.width / 2, y: shellBottomTexture.size().height / 1.8), duration: slideInDur)
        let slideInBottomBack = SKAction.move(to: CGPoint(x: size.width / 2, y: shellBottomTexture.size().height / 2), duration: slideInDur * 0.05)
        
        slideInLeft.timingMode = .easeIn
        slideInRight.timingMode = .easeIn
        slideInTop.timingMode = .easeIn
        slideInBottom.timingMode = .easeIn
        
        shellLeft.run(SKAction.sequence([slideInLeft, slideInLeftBack]))
        shellRight.run(SKAction.sequence([slideInRight, slideInRightBack]))
        shellTop.run(SKAction.sequence([slideInTop, slideInTopBack]))
        shellBottom.run(SKAction.sequence([slideInBottom, slideInBottomBack]), completion: {
            AudioManager.sharedInstance.playLoop("menu-beeping")
            AudioManager.sharedInstance.playLoop("music")
            AudioManager.sharedInstance.setVolume("music", volume: 0.9, dur: 0)
        })
        
        AudioManager.sharedInstance.play("shell-move")
        
        // Interface Blink In Animation
        
        let wait = SKAction.wait(forDuration: slideInDur)
        let firstFadeIn = SKAction.fadeAlpha(to: 0.4, duration: 0.5 * timeScale)
        let firstFadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5 * timeScale)
        let secondFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5 * timeScale)
        let flickerIn = SKAction.sequence([wait, firstFadeIn, firstFadeOut, secondFadeIn])
        
        border.run(flickerIn)
        title.run(flickerIn)
        box1.run(flickerIn)
        box2.run(flickerIn)
        box3.run(flickerIn)

        scoreButton.run(flickerIn)
        soundToggle.run(flickerIn)
        playButton.run(flickerIn)
        
        // Setup High Score Box
        setupHighScoreBox()
    }
    
    override func didMove(to view: SKView) {
        if hasBeenPresentedOnce == true {
            self.childNode(withName: "border")?.alpha = 0
            self.childNode(withName: "title")?.alpha = 0
            self.childNode(withName: "box1")?.alpha = 0
            self.childNode(withName: "box2")?.alpha = 0
            self.childNode(withName: "box3")?.alpha = 0
            self.childNode(withName: "scoreButton")?.alpha = 0
            self.childNode(withName: "soundToggle")?.alpha = 0
            self.childNode(withName: "playButton")?.alpha = 0
            
            let zoomOut = SKAction.scale(to: 1.0, duration: 0.25 * timeScale)
            camera?.run(zoomOut, completion: {
                let firstFadeIn = SKAction.fadeAlpha(to: 0.4, duration: 0.5 * self.timeScale)
                let firstFadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5 * self.timeScale)
                let secondFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5 * self.timeScale)
                let flickerIn = SKAction.sequence([firstFadeIn, firstFadeOut, secondFadeIn])
                
                self.childNode(withName: "border")?.run(flickerIn)
                self.childNode(withName: "title")?.run(flickerIn)
                self.childNode(withName: "box1")?.run(flickerIn)
                self.childNode(withName: "box2")?.run(flickerIn)
                self.childNode(withName: "box3")?.run(flickerIn)
                self.childNode(withName: "scoreButton")?.run(flickerIn)
                self.childNode(withName: "soundToggle")?.run(flickerIn)
                self.childNode(withName: "playButton")?.run(flickerIn)
                
                AudioManager.sharedInstance.playLoop("menu-beeping")
                AudioManager.sharedInstance.playLoop("music")
                AudioManager.sharedInstance.setVolume("music", volume: 0.9, dur: 0)
            })
        } else {
            hasBeenPresentedOnce = true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    func presentGameScene() {
        let animationDur = TimeInterval(0.25)
        
        // Fade out animation
        let fadeOut = SKAction.fadeOut(withDuration: animationDur)
        self.childNode(withName: "border")?.run(fadeOut)
        self.childNode(withName: "title")?.run(fadeOut)
        self.childNode(withName: "box1")?.run(fadeOut)
        self.childNode(withName: "box2")?.run(fadeOut)
        self.childNode(withName: "box3")?.run(fadeOut)
        self.childNode(withName: "scoreButton")?.run(fadeOut)
        self.childNode(withName: "soundToggle")?.run(fadeOut)
        self.childNode(withName: "playButton")?.run(fadeOut)
        
        // Zoom animation
        let zoomInAction = SKAction.scale(to: 0.75, duration: animationDur)
        camera?.run(zoomInAction, completion: {            
            // Present the scene
            let gameScene = GameScene(size: self.size, menu: self, scaleMode: .aspectFill)
            let transition = SKTransition.fade(with: self.backgroundColor, duration: 1)
            gameScene.scaleMode = .aspectFit
            self.view?.presentScene(gameScene, transition: transition)
        })
        
        AudioManager.sharedInstance.stop("menu-beeping")
    }
    
    func onButtonPress(named: String) {
        switch named {
        case "playButton":
            if childNode(withName: "playButton")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-high")
                presentGameScene()
            }
        
        case "soundToggle":
            if childNode(withName: "soundToggle")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-low")
                AudioManager.sharedInstance.toggleSound()
            }
        case "scoreButton":
            if childNode(withName: "scoreButton")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-low")
                showHighScoreBox()
            }
        case "exitButton":
            if childNode(withName: "scoreBox")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-low")
                hideHighScoreBox()
            }
        default:
            break
        }
    }
    
    func onButtonDown(named: String?) {
        guard let name = named else { return }
        
        switch name {
        case "soundToggle":
            print("\(name) pressed")
            
        default:
            print("No action registered for onButtonDown(_:) of ", named!, " button")
        }
    }
    
    func showHighScoreBox() {
        // Get saved high score
        var highScore: Int = 0
        let userDefaults = UserDefaults.standard
        if let value = userDefaults.object(forKey: "highScore") {
            highScore = value as! Int
        }
        let scoreLabel = scoreBox.childNode(withName: "scoreLabel") as! SKScoreLabel
        scoreLabel.setValue(to: highScore)
        
        scoreBox.alpha = 1
    }
    
    func hideHighScoreBox() {
        scoreBox.alpha = 0
    }
    
    func setupHighScoreBox() {
        scoreBox = SKSpriteNode(imageNamed: "playerdeathyellow")
        scoreBox.name = "scoreBox"
        scoreBox.size = CGSize(width: self.size.width * 0.8, height: self.size.height * 0.8)
        scoreBox.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        scoreBox.zPosition = 100
        scoreBox.alpha = 0
        addChild(scoreBox)
        
        let scoreLabel = SKScoreLabel(value: 0)
        scoreLabel.name = "scoreLabel"
        scoreLabel.zPosition = 101
        scoreBox.addChild(scoreLabel)
        
        let exitButton = SKButton(nameForImageNormal: "exit-button", nameForImageNormalHighlight: "exit-button")
        exitButton.name = "exitButton"
        let posX = scoreBox.size.width / 2 - exitButton.size.width / 2
        let posY = scoreBox.size.height / 2 - exitButton.size.height / 2
        exitButton.position = CGPoint(x: posX, y: posY)
        exitButton.delegate = self
        exitButton.zPosition = 101
        scoreBox.addChild(exitButton)
    }
}
