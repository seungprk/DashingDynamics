//
//  MenuScene.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/9/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        
        let fontName = "Helvetica Neue Condensed Black"
        
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        guard let data = NSDictionary(contentsOf: url!) else { print("No PlayerData.plist") ; return }
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
        
        /*
        // Save value to plist key
        let saveAccount = NSDictionary(dictionary: ["Test": "Test String"])
        let url = Bundle.main.url(forResource: "PlayerData", withExtension: "plist")
        saveAccount.write(to: url!, atomically: false)
        */
        
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
        let transition = SKTransition.moveIn(with: .up, duration: 0.5)
        
        if let view = self.view {
            view.presentScene(gameScene, transition: transition)
        }
    }
    
}
