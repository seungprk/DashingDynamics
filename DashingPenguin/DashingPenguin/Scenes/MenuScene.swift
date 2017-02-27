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
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .init(red: 0.05, green: 0.09, blue: 0.09, alpha: 1)
        
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
        shellLeft.position = CGPoint(x: shellLeftTexture.size().width / 2, y: size.height / 2)
        let shellRight = SKSpriteNode(texture: shellRightTexture)
        shellRight.position = CGPoint(x: size.width - shellRightTexture.size().width / 2, y: size.height / 2)
        let shellTop = SKSpriteNode(texture: shellTopTexture)
        shellTop.position = CGPoint(x: size.width / 2, y: size.height - shellTopTexture.size().height / 2)
        let shellBottom = SKSpriteNode(texture: shellBottomTexture)
        shellBottom.position = CGPoint(x: size.width / 2, y: shellBottomTexture.size().height / 2)
        
        addChild(shellLeft)
        addChild(shellRight)
        addChild(shellTop)
        addChild(shellBottom)
        
        // Add Static Graphics
        
        let border = SKSpriteNode(imageNamed: "menu-border")
        border.texture?.filteringMode = .nearest
        border.position = CGPoint(x: frame.midX, y: frame.midY + 26)
        addChild(border)
        
        let title = SKSpriteNode(imageNamed: "menu-title")
        title.texture?.filteringMode = .nearest
        title.position = CGPoint(x: frame.midX, y: frame.midY + 107)
        addChild(title)
        
        let box1 = SKSpriteNode(imageNamed: "menu-box1")
        box1.texture?.filteringMode = .nearest
        box1.position = CGPoint(x: frame.midX, y: frame.midY + 73)
        addChild(box1)
        
        let box2 = SKSpriteNode(imageNamed: "menu-box2")
        box2.texture?.filteringMode = .nearest
        box2.position = CGPoint(x: frame.midX, y: frame.midY + 30)
        addChild(box2)
        
        let box3 = SKSpriteNode(imageNamed: "menu-box3")
        box3.texture?.filteringMode = .nearest
        box3.position = CGPoint(x: frame.midX, y: frame.midY - 47)
        addChild(box3)
        
        // Add Buttons
        
        let playButton = SKButton(nameForImageNormal: "menu-play", nameForImageNormalHighlight: "menu-play-active")
        playButton.name = "playButton"
        playButton.delegate = self
        playButton.texture?.filteringMode = .nearest
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 104)
        addChild(playButton)
        
        let scoreButton = SKButton(nameForImageNormal: "menu-score", nameForImageNormalHighlight: "menu-score-active")
        scoreButton.name = "scoreButton"
        scoreButton.delegate = self
        scoreButton.texture?.filteringMode = .nearest
        scoreButton.position = CGPoint(x: size.width / 2 + 31, y: size.height / 2 - 5)
        addChild(scoreButton)
        
        // Add Sound Toggle
        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist"); return }
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool else { print("no key isSoundOn"); return }
        
        let soundToggle = SKToggle(isOn: isSoundOn, imageNormal: "menu-sound", imageHighlight: "menu-sound-active", imageOff: "menu-sound-off", imageOffHighlight: "menu-sound-off-active")
        soundToggle.name = "soundToggle"
        soundToggle.delegate = self
        soundToggle.position = CGPoint(x: size.width / 2 - 31, y: size.height / 2 - 5)
        addChild(soundToggle)
        
        // Misc
        AudioManager.sharedInstance.preInit()
    }
    
    override func didMove(to view: SKView) {
        /*for node in nodesToAnimateIn {
            blinkIn(node: node)
        }*/
    }
    
    override func update(_ currentTime: TimeInterval) {
        /*
        if let motion = motionManager?.accelerometerData {
            print("\(motion.acceleration.x) \(motion.acceleration.y)")
            
            let mX = CGFloat(motion.acceleration.x * 10)
            let mY = CGFloat(motion.acceleration.y * 10)
//            scene?.run(.move(to: CGPoint(x: mX, y: mY), duration: 0.1) )
            
            //view?.frame.origin.x = mX
            //view?.frame.origin.y = mY
            
            background1?.position = CGPoint(x: frame.midX - mX, y: frame.midY - mY)
            background2?.position = CGPoint(x: frame.midX - mX * 4, y: frame.midY - mY * 4)
        }
        */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchLocation = t.location(in: self)
            for node in nodes(at: touchLocation) {
                if node.name == "playLabel" {
                    presentGameScene()
                }
            }
        }
    }
    
    func presentGameScene() {
        let gameScene = GameScene(size: self.size, menu: self, scaleMode: .aspectFill)
        let transition = SKTransition.fade(withDuration: 2)
        if let view = self.view {
            view.presentScene(gameScene, transition: transition)
        }
        
        AudioManager.sharedInstance.preInit()
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
            AudioManager.sharedInstance.play("beep-high")
            presentGameScene()
        
        case "soundToggle":
            AudioManager.sharedInstance.play("beep-low")
            toggleSound()
        
        case "scoreButton":
            AudioManager.sharedInstance.play("beep-low")
            
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
