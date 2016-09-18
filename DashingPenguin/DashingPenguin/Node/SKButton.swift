//
//  SKButton.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/17/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

enum SKButtonType {
    case pause
}

protocol SKButtonDelegate {
    func onButtonPress(type: SKButtonType)
}

class SKButton: SKSpriteNode {
    
    var delegate: SKButtonDelegate?
    let type: SKButtonType
    
    init(ofType type: SKButtonType) {
        self.type = type
        super.init(texture: nil, color: SKColor.init(red: 0, green: 0, blue: 1, alpha: 0.2) , size: CGSize(width: 50, height: 50))
        let label = SKLabelNode(text: "II")
        label.zPosition = GameplayConfiguration.HeightOf.controlInputNode * 3
        label.fontName = "Helvetica Neue Bold"
        label.position = CGPoint(x: 0, y: -self.frame.height * 0.25) //.zero
        label.fontColor = .black
        label.fontSize = 36
        addChild(label)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.onButtonPress(type: type)
    }
    
}
