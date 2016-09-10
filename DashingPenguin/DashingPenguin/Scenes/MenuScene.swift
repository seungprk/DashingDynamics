//
//  MenuScene.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/9/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

let SoundStringOn  = "Sound On"
let SoundStringOff = "Sound Off"

class MenuScene: SKScene {
    
    var soundLabel = SKLabelNode(text: "unititialized")
    
    override func didMove(to view: SKView) {
        
        let fontName = "Helvetica Neue Condensed Black"
        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist"); return }
        let string = data.value(forKey: "Title") as? String
        
        let label = SKLabelNode(text: string)
        label.position = CGPoint(x: frame.midX, y: frame.midY + label.frame.height * 2)
        label.fontName = fontName
        addChild(label)
        
        let playLabel = SKLabelNode(text: "Play")
        playLabel.name = "playLabel"
        playLabel.fontName = fontName
        playLabel.fontSize = 48
        playLabel.position = label.position
        playLabel.position.y -= playLabel.frame.height * 4
        addChild(playLabel)
        
        guard let isSoundOn = data.value(forKey: "isSoundOn") as? Bool else { print("no key isSoundOn"); return }
        soundLabel.text = isSoundOn ? SoundStringOn : SoundStringOff
        soundLabel.name = "soundLabel"
        soundLabel.fontName = fontName
        soundLabel.position = playLabel.position
        soundLabel.position.y -= soundLabel.frame.height * 2
        addChild(soundLabel)
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
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        
        if let view = self.view {
            view.presentScene(gameScene, transition: transition)
        }
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
        
        soundLabel.text = !isSoundOn ? SoundStringOn : SoundStringOff
    }
    
}
