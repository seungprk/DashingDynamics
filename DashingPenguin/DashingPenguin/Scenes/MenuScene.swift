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
        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist"); return }
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool else { print("no key isSoundOn"); return }
        
        let soundToggle = SKToggle(isOn: isSoundOn, imageNormal: "menu-sound", imageHighlight: "menu-sound-active", imageOff: "menu-sound-off", imageOffHighlight: "menu-sound-off-active")
        soundToggle.name = "soundToggle"
        soundToggle.delegate = self
        soundToggle.position = CGPoint(x: size.width / 2 - 31, y: size.height / 2 - 5)
        soundToggle.alpha = 0
        addChild(soundToggle)
        
        // Shell Slide In Animation
        
        let slideInDur = TimeInterval(2)
        let slideInLeft = SKAction.move(to: CGPoint(x: shellLeftTexture.size().width / 2, y: size.height / 2 + 3), duration: slideInDur)
        let slideInRight = SKAction.move(to: CGPoint(x: size.width - shellRightTexture.size().width / 2, y: size.height / 2 + 3), duration: slideInDur)
        let slideInTop = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height - shellTopTexture.size().height / 2), duration: slideInDur)
        let slideInBottom = SKAction.move(to: CGPoint(x: size.width / 2, y: shellBottomTexture.size().height / 2), duration: slideInDur)
        
        shellLeft.run(slideInLeft)
        shellRight.run(slideInRight)
        shellTop.run(slideInTop)
        shellBottom.run(slideInBottom, completion: {
            AudioManager.sharedInstance.playLoop("menu-beeping")
            AudioManager.sharedInstance.playLoop("music")
            AudioManager.sharedInstance.setVolume("music", volume: 1.0, dur: 0)
        })
        
        AudioManager.sharedInstance.play("shell-move")
        
        // Interface Blink In Animation
        
        let wait = SKAction.wait(forDuration: slideInDur)
        let firstFadeIn = SKAction.fadeAlpha(to: 0.4, duration: 0.5)
        let firstFadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let secondFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
        let flickerIn = SKAction.sequence([wait, firstFadeIn, firstFadeOut, secondFadeIn])
        
        border.run(flickerIn)
        title.run(flickerIn)
        box1.run(flickerIn)
        box2.run(flickerIn)
        box3.run(flickerIn)
        scoreButton.run(flickerIn)
        soundToggle.run(flickerIn)
        playButton.run(flickerIn)
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
            
            let zoomOut = SKAction.scale(to: 1.0, duration: 0.25)
            camera?.run(zoomOut, completion: {
                let firstFadeIn = SKAction.fadeAlpha(to: 0.4, duration: 0.5)
                let firstFadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
                let secondFadeIn = SKAction.fadeAlpha(to: 1, duration: 0.5)
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
                AudioManager.sharedInstance.setVolume("music", volume: 1.0, dur: 0)
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
            self.view?.presentScene(gameScene, transition: transition)
        })
        
        AudioManager.sharedInstance.stop("menu-beeping")
    }
    
    func toggleSound() {
        
        guard let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
            else { print("can't make PlayerData.plist url") ; return }
        guard let data = NSDictionary(contentsOf: url)
            else { print("No PlayerData.plist") ; return }
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool
            else { print("no key isSoundOn"); return }

        let newData = NSMutableDictionary(dictionary: data)
        newData.setValue(!isSoundOn, forKey: "isSoundOn")
        newData.write(to: url, atomically: false)
    }
    
    func onButtonPress(named: String) {
        print(named)
        
        switch named {
        case "playButton":
            if childNode(withName: "playButton")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-high")
                presentGameScene()
            }
        
        case "soundToggle":
            if childNode(withName: "soundToggle")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-low")
                toggleSound()
            }
        case "scoreButton":
            if childNode(withName: "scoreButton")?.alpha == 1 {
                AudioManager.sharedInstance.play("beep-low")
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
            print("No action registered for onButtonDown(_:) of \(named) button")
        }
    }
}
