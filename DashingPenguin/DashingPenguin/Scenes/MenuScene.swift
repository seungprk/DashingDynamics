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

let SoundStringOn  = "Sound On"
let SoundStringOff = "Sound Off"

class MenuScene: SKScene, SKButtonDelegate {
    
    var soundLabel = SKLabelNode(text: "unititialized")

    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .init(red: 0.05, green: 0.09, blue: 0.09, alpha: 1)
        
        let fontName = "Helvetica Neue Condensed Black"
        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist"); return }
        let string = data.value(forKey: "Title") as? String
        
        let label = SKLabelNode(text: string)
        label.position = CGPoint(x: frame.midX, y: frame.midY + label.frame.height * 2)
        label.fontName = fontName
        addChild(label)
        
        let playButton = SKButton(size: CGSize(width: 200, height: 40), nameForImageNormal: nil, nameForImageNormalHighlight: nil)
        playButton.name = "playButton"
        playButton.delegate = self
        playButton.position = CGPoint(x: label.position.x, y: label.position.y - playButton.frame.height * 4)
        
        let playLabel = SKLabelNode(text: "Play")
        playLabel.name = "playLabel"
        playLabel.fontName = fontName
        playLabel.fontSize = 24
        playLabel.position = CGPoint.zero
        
        playButton.addChild(playLabel)
        addChild(playButton)
        
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool else { print("no key isSoundOn"); return }
        soundLabel.text = isSoundOn ? SoundStringOn : SoundStringOff
        soundLabel.name = "soundLabel"
        soundLabel.fontName = fontName
        soundLabel.position = playButton.position
        soundLabel.position.y -= soundLabel.frame.height * 2
        addChild(soundLabel)
        
        
        let soundButton = SKToggle(size: CGSize(width: 40, height: 40), isOn: isSoundOn, imageNormal: "sound_on", imageHighlight: "sound_on_highlight", imageOff: "sound_off", imageOffHighlight: "sound_off_highlight")
        soundButton.name = "soundButton"
        soundButton.delegate = self
        soundButton.position = CGPoint(x: 50, y: 200)
        addChild(soundButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let touchLocation = t.location(in: self)
            for node in nodes(at: touchLocation) {
                if node.name == "playLabel" {
                    presentGameScene()
                } else if node.name == "soundLabel" {
                    toggleSound()
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
        
        soundLabel.text = !isSoundOn ? SoundStringOn : SoundStringOff
    }
    
    func onButtonPress(named: String) {
        print(named)
        
        switch named {
        case "playButton":
            presentGameScene()
            
        default:
            break
        }
    }
}
