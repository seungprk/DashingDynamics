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
    
    var nodesToAnimateIn = [SKNode]()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // tilemap iOS 10.0+ only
//        let backgroundTexture = SKTexture(imageNamed: "menu-background")
//        let backgroundDefinition = SKTileDefinition(texture: backgroundTexture)
//        let backgroundGroup = SKTileGroup(tileDefinition: backgroundDefinition)
        
        let backgroundTexture = SKTexture(imageNamed: "menu-background")
        backgroundTexture.filteringMode = .nearest
        let bgSize = backgroundTexture.size()
        let cols = size.width / bgSize.width
        let rows = size.height / bgSize.height
        print("SIZE : \(bgSize)")
        
        for c in 0...Int(cols) {
            for r in 0...Int(rows) {
                let bgTile = SKSpriteNode(texture: backgroundTexture)
                bgTile.position = CGPoint(
                    x: CGFloat(c) * cols * 2.2, // + size.width / 2,
                    y: CGFloat(r) * rows * 1.25 + 10) // + size.height / 2)
                bgTile.zPosition = -10000
                addChild(bgTile)
            }
        }
        
        backgroundColor = .init(red: 0.05, green: 0.09, blue: 0.09, alpha: 1)
        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist"); return }
        
        let logo = SKSpriteNode(imageNamed: "menu-title")
        logo.size = CGSize(width: 120, height: 40)
        logo.texture?.filteringMode = .nearest
        logo.position = CGPoint(x: frame.midX, y: frame.midY + 60)
        addChild(logo)
        
        
        let playButton = SKButton(size: CGSize(width: 120, height: 40), nameForImageNormal: "playbutton", nameForImageNormalHighlight: "playbutton-highlight")
        playButton.name = "playButton"
        playButton.delegate = self
        playButton.texture?.filteringMode = .nearest
        playButton.position = CGPoint(x: size.width / 2 - 0.5, y: size.height * 0.2 - 4.5)
        addChild(playButton)
        
        
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool else { print("no key isSoundOn"); return }

        let soundToggle = SKToggle(size: CGSize(width: 40.5, height: 20.5), isOn: isSoundOn, imageNormal: "sound-on", imageHighlight: "sound-on-highlight", imageOff: "sound-off", imageOffHighlight: "sound-off-highlight")
        soundToggle.name = "soundToggle"
        soundToggle.delegate = self
        soundToggle.texture?.filteringMode = .nearest
        soundToggle.position = CGPoint(x: size.width / 2 - soundToggle.size.width + 0.5, y: size.height * 0.8 + 13.2)
        addChild(soundToggle)
        
        let outline = SKSpriteNode(imageNamed: "robot-blueprint-outline")
        outline.texture?.filteringMode = .nearest
        outline.position = CGPoint(x: frame.midX, y: frame.midY - 20)
        addChild(outline)
        
        let panSpeed: TimeInterval = 4
        let slowPan = SKAction.sequence([ SKAction.moveBy(x: 1, y: 0, duration: panSpeed ),
                                          SKAction.moveBy(x: 0, y: 1, duration: panSpeed ),
                                          SKAction.moveBy(x: -1, y: -1, duration: panSpeed) ])
        outline.run(SKAction.repeatForever(slowPan))

        
        /*
        let leaderboardButton = SKButton(size: CGSize(width: 30, height: 30), nameForImageNormal: "leaderboard", nameForImageNormalHighlight: "leaderboard_highlight")
        leaderboardButton.name = "leaderboardButton"
        leaderboardButton.delegate = self
        leaderboardButton.texture?.filteringMode = .nearest
        leaderboardButton.position = CGPoint(x: size.width / 2 + leaderboardButton.size.width, y: size.height * 0.8)
        addChild(leaderboardButton)
        */
        
        /*
        let borderInset: CGFloat = 10
        let border = SKShapeNode(rect: CGRect(x: borderInset, y: borderInset, width: size.width - borderInset * 2, height: size.height - borderInset * 2))
        border.strokeColor = .init(red: 43/255, green: 237/255, blue: 230/255, alpha: 0.5)
        border.isUserInteractionEnabled = false
        border.zPosition = -100000
        addChild(border)
        */
        
        /*
        background1 = SKSpriteNode(imageNamed: "background_1")
        background2 = SKSpriteNode(imageNamed: "background_2")
        
        background1?.size = CGSize(width: size.width, height: size.height)
        background2?.size = CGSize(width: size.width, height: size.height)
        
        background1?.position = CGPoint(x: frame.midX, y: frame.midY)
        background2?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        background1?.zPosition = -100000
        background2?.zPosition = -100000
        
        addChild(background1!)
        addChild(background2!)
        */
        
        //motionManager = CMMotionManager()
        //motionManager?.startAccelerometerUpdates()
        
        /*
        for child in children {
            nodesToAnimateIn.append(child)
        }
        */
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
    
    func movePixel(x: CGFloat, y: CGFloat, isHorizontal: Bool, iter: Int) {
        let pixel = SKSpriteNode(imageNamed: "white-pixel")
        pixel.position = CGPoint(x: x, y: y)
        if isHorizontal {
            
            let shift = SKAction.moveTo(x: 1, duration: 0.2)
            pixel.run(shift)
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
        
        AudioManager.sharedInstance.preInit()
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
    
    var blinkCounter = 0
    
    func blinkIn(node: SKNode) {
        blinkCounter += 1
        let blinkIn = SKAction.fadeIn(withDuration: 0)
        let blinkOut = SKAction.fadeOut(withDuration: 0)
        let initialDelay = SKAction.wait(forDuration: 0.2 * TimeInterval(blinkCounter))
        let delay = SKAction.wait(forDuration: 0.04)
        
        let blinkInSequence = SKAction.repeat(SKAction.sequence([delay, blinkOut, delay, blinkIn]), count: 4)

        node.alpha = 0
        node.run(SKAction.sequence([initialDelay, blinkIn, blinkInSequence, periodicBlink()]))
    }
    
    func periodicBlink() -> SKAction {
    // private let periodicBlink: SKAction = {
        let randomOffset = TimeInterval( Double(arc4random_uniform(40)) / 10.0 )// * 10.0
        
        let blinkIn = SKAction.fadeIn(withDuration: 0)
        let blinkOut = SKAction.fadeOut(withDuration: 0)
        let delay = SKAction.wait(forDuration: 0.04)
        
        let blinkSequence = SKAction.repeat(SKAction.sequence([delay, blinkOut, delay, blinkIn]), count: 4)
        let forever = SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 6), blinkSequence]))
        return SKAction.sequence([SKAction.wait(forDuration: randomOffset), forever])
    }
}
