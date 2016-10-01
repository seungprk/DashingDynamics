//
//  SKToggle.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/20/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

class SKToggle: SKButton {
    
    let textureOff: SKTexture?
    let textureOffHighlight: SKTexture?
    
    var isOn: Bool {
        didSet {
            if let texture = isOn ? textureNormal : textureOff {
                self.texture = texture
            }
        }
    }
    
    init(size: CGSize, isOn: Bool, imageNormal: String?, imageHighlight: String?, imageOff: String?, imageOffHighlight: String?) {
        
        if let imageOffName = imageOff {
            self.textureOff = SKTexture(imageNamed: imageOffName)
        } else {
            self.textureOff = nil
        }
        if let imageOffHighlightName = imageOffHighlight {
            self.textureOffHighlight = SKTexture(imageNamed: imageOffHighlightName)
        } else {
            self.textureOffHighlight = nil
        }
        self.isOn = isOn
        
        super.init(size: size, nameForImageNormal: imageNormal, nameForImageNormalHighlight: imageHighlight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setState(to isOn: Bool) {
        self.isOn = isOn
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let texture = isOn ? textureNormalHighlight : textureOffHighlight {
            self.texture = texture
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let location = touches.first?.location(in: self.scene!) {
            if self.contains(location) {
                
                isOn = !isOn
                if let texture = isOn ? textureNormal : textureOff {
                    self.texture = texture
                }
                
                if let name = self.name {
                    delegate?.onButtonPress(named: name)
                } else {
                    print("Pressed button has no name")
                }
            } else {
                if let texture = isOn ? textureNormal : textureOff {
                    self.texture = texture
                }
            }
        }
    }
}
