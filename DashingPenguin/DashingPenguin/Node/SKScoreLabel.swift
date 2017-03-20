//
//  SKScoreLabel.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 3/12/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit

class SKScoreLabel: SKNode {
    
    var digits = [SKSpriteNode]()
    let fontsize: CGSize
    let numberFont = SKTextureAtlas(named: "number-font").textures()
    
    /// The size containing digit sprites.
    var size: CGSize {
        get {
            return CGSize(
                width: fontsize.width * CGFloat(digits.count),
                height: fontsize.height
            )
        }
    }
    
    override init() {
        fontsize = numberFont.first!.size()
        super.init()
        
    #if DEBUG
        let center = SKSpriteNode(color: .red, size: CGSize(width: 1, height: 1))
        center.zPosition = 300000000000000000 // just needs to be above anything
        addChild(center)
    #endif
    }
    
    convenience init(value: Int) {
        self.init()
        self.setValue(to: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValue(to number: Int) {
        self.removeDigitNodes()
        self.digits = number.digits()
                            .enumerated()
                            .map(toSprite)
    }
    
    private func removeDigitNodes() {
        for _ in 0..<self.digits.count {
            self.digits.popLast()?.removeFromParent()
        }
    }
    
    private func toSprite(at index: Int, for digit: Int) -> SKSpriteNode {
        let node = SKSpriteNode(texture: self.numberFont[digit])
        let offset = CGFloat(index) - (CGFloat(digits.count - 1) / 2)
        node.position.x = offset * self.fontsize.width
        self.addChild(node)
        return node
    }
}

extension SKTextureAtlas {
    /// Creates an array of textures from the data stored in the atlas object.
    func textures() -> [SKTexture] {
        return self.textureNames.sorted().map({ name in
            return self.textureNamed(name)
        })
    }
}

extension Int {
    /// Converts an integer into an array of its digits.
    func digits() -> [Int] {
        return String(self).characters.map({ character in
            let charString = String(character)
            // Convert string to integer
            return Int(charString, radix: 10)!
        })
    }
}
