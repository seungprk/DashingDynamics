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
    
    var motionManager: CMMotionManager?
    
    var background1: SKSpriteNode?
    var background2: SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .init(red: 0.05, green: 0.09, blue: 0.09, alpha: 1)
        
//        let fontName = "Helvetica Neue Condensed Black"
//        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist"); return }
//        let string = data.value(forKey: "Title") as? String
        
        let logo = SKSpriteNode(imageNamed: "ahi_logo")
        logo.size = CGSize(width: 142, height: 63)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + logo.frame.height)
        addChild(logo)
        
        let playButton = SKButton(size: CGSize(width: 120, height: 40), nameForImageNormal: "play_button", nameForImageNormalHighlight: "play_button_highlight")
        playButton.name = "playButton"
        playButton.delegate = self
        playButton.position = CGPoint(x: logo.position.x, y: logo.position.y - playButton.frame.height * 6)
        addChild(playButton)
        
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool else { print("no key isSoundOn"); return }

        let soundToggle = SKToggle(size: CGSize(width: 40, height: 40), isOn: isSoundOn, imageNormal: "sound_on", imageHighlight: "sound_on_highlight", imageOff: "sound_off", imageOffHighlight: "sound_off_highlight")
        soundToggle.name = "soundToggle"
        soundToggle.delegate = self
        soundToggle.position = CGPoint(x: size.width / 2 - soundToggle.size.width, y: size.height - 20 - soundToggle.size.height)
        addChild(soundToggle)
        
        let leaderboardButton = SKButton(size: CGSize(width: 40, height: 40), nameForImageNormal: "leaderboard", nameForImageNormalHighlight: "leaderboard_highlight")
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.delegate = self
        leaderboardButton.position = CGPoint(x: size.width / 2 + leaderboardButton.size.width, y: size.height - 20 - leaderboardButton.size.height)
        addChild(leaderboardButton)
        
        let borderInset: CGFloat = 20
        let border = SKShapeNode(rect: CGRect(x: borderInset, y: borderInset, width: size.width - borderInset * 2, height: size.height - borderInset * 2))
        border.strokeColor = .init(red: 43/255, green: 237/255, blue: 230/255, alpha: 0.5)
        border.isUserInteractionEnabled = false
        border.zPosition = -100000
        addChild(border)
        
        background1 = SKSpriteNode(imageNamed: "background_1")
        background2 = SKSpriteNode(imageNamed: "background_2")
        
        background1?.position = CGPoint(x: frame.midX, y: frame.midY)
        background2?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        background1?.zPosition = -100000
        background2?.zPosition = -100000
        
        addChild(background1!)
        addChild(background2!)
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let motion = motionManager?.accelerometerData {
            print("\(motion.acceleration.x) \(motion.acceleration.y)")
            
            let mX = CGFloat(motion.acceleration.x * 20)
            let mY = CGFloat(motion.acceleration.y * 20)
//            scene?.run(.move(to: CGPoint(x: mX, y: mY), duration: 0.1) )
            
            //view?.frame.origin.x = mX
            //view?.frame.origin.y = mY
            
            background1?.position = CGPoint(x: frame.midX - mX, y: frame.midY - mY)
            background2?.position = CGPoint(x: frame.midX - mX * 4, y: frame.midY - mY * 4)
        }
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
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
        let moveOutToLeft = SKAction.move(to: CGPoint(x: view!.center.x - view!.frame.width, y: view!.center.y), duration: 0.5)
        fadeOut.timingMode = .easeIn
        moveOutToLeft.timingMode = .easeIn
        
        // Set Up and Present Main Game Scene
        let gameScene = GameScene(size: self.size)
        gameScene.scaleMode = SKSceneScaleMode.aspectFill
        gameScene.menuScene = self
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        
        if let view = self.view {
            view.presentScene(gameScene, transition: transition)
        }
    }
    
    func toggleSound() {
        AudioManager.sharedInstance.play("charge")
        
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
            presentGameScene()
        
        case "soundToggle":
            toggleSound()
            
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
