//
//  SKButton.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/17/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

//enum SKButtonType {
//    case pause
//    case sound
//    case music
//    case beginPlay
//    case gameCenter
//    case credits
//}

@objc protocol SKButtonDelegate {
    func onButtonPress(named: String)
    @objc optional func onButtonDown(named: String?)
}


class SKButton: SKSpriteNode {
    
    var delegate: SKButtonDelegate?
    
    let textureNormal: SKTexture?
    let textureNormalHighlight: SKTexture?
    
    init(size: CGSize, nameForImageNormal: String?, nameForImageNormalHighlight: String?) {
        
        if let nameNormal = nameForImageNormal {
            textureNormal = SKTexture(imageNamed: nameNormal)
        } else {
            textureNormal = nil
        }
        
        if let nameHighlight = nameForImageNormalHighlight {
            textureNormalHighlight = SKTexture(imageNamed: nameHighlight)
        } else {
            textureNormalHighlight = nil
        }
        
        super.init(texture: textureNormal, color: .clear, size: size)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let textureHiglight = textureNormalHighlight {
            self.texture = textureHiglight
        }

        delegate?.onButtonDown?(named: name)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.texture = textureNormal
        
        if let name = self.name {
            delegate?.onButtonPress(named: name)
        } else {
            print("Pressed button has no name")
        }
    }
    
}
