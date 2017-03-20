//
//  SKScoreLabel.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 3/12/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit

class SKScoreLabel: SKNode {
    /// References the digit sprite nodes.
    private var digits: [SKSpriteNode] = [SKSpriteNode]() {
        willSet(value) {
            return self.removeDigitNodes()
        }
    }
    
    /// The number textures reused between score labels.
    private static let numberFont = SKTextureAtlas(named: "number-font").textures()
    
    /// Stores the font size.
    private let fontsize: CGSize

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
        fontsize = SKScoreLabel.numberFont.first!.size()
        super.init()
        
        #if DEBUG
            // Adds a red dot to show where the label node's center is.
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
    
    /// Updates the sprite nodes that make up the score.
    func setValue(to number: Int) {
        let digits = number.digits()
        
        // Adds a new number sprite node to the label node.
        func toSprite(index: Int, digit: Int) -> SKSpriteNode {
            let xOffset = getOffset(index, digits.count)
            let node = self.numberNode(digit: digit, at: xOffset)
            self.addChild(node)
            return node
        }
        self.digits = digits.enumerated().map(toSprite)
    }
    
    /// Removes nodes from digit array.
    private func removeDigitNodes() {
        for _ in 0..<self.digits.count {
            self.digits.popLast()?.removeFromParent()
        }
    }
    
    /// Creates a sprite node from the given digit and x position.
    private func numberNode(digit: Int, at offset: CGFloat) -> SKSpriteNode {
        let node = SKSpriteNode(texture: SKScoreLabel.numberFont[digit])
        node.position.x = offset
        return node
    }
    
    /// Returns an offset from the center of the parent label node.
    private func getOffset(_ index: Int, _ digitCount: Int) -> CGFloat {
        let indexFromCenter = CGFloat(index) - (CGFloat(digitCount - 1) / 2)
        return indexFromCenter * self.fontsize.width
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
