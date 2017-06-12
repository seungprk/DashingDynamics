//
//  SKScoreLabel.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 3/12/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//  color: 5fcde4

import SpriteKit

class SKScoreLabel: SKNode {
    /// References the digit sprite nodes.
    private var digits: [SKSpriteNode] = [SKSpriteNode]() {
        willSet(value) {
            // Remove old nodes from the array and parent label.
            while !digits.isEmpty {
                self.digits.popLast()?.removeFromParent()
            }
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
    
    var _blendColor: UIColor?
    var blendColor: UIColor? {
        get {
            return self._blendColor
        }
        set(value) {
            self._blendColor = value
            self.digits.forEach { node in
                if let c = self._blendColor {
                    node.color = c
                    node.colorBlendFactor = 1.0
                }
            }
        }
    }
    
    /// Sets the fontsize constant and calls SKNode's initializer.
    override init() {
        fontsize = SKScoreLabel.numberFont.first!.size()
        super.init()
        
//        #if DEBUG
//            // Adds a red dot to show where the label node's center is.
//            addChild(SKSpriteNode.dot())
//        #endif
    }
    
    /// Creates a new score label with a given initial value.
    convenience init(value: Int) {
        self.init()
        self.setValue(to: value)
    }
    
    /// Don't load from file.
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
            
            if let c = self._blendColor {
                node.color = c
                node.colorBlendFactor = 1.0
            }
            
            self.addChild(node)
            return node
        }
        self.digits = digits.enumerated().map(toSprite)
    }
    
    /// Creates a sprite node from the given digit and x position.
    private func numberNode(digit: Int, at offset: CGFloat) -> SKSpriteNode {
        let node = SKSpriteNode(texture: SKScoreLabel.numberFont[digit])
        node.position.x = offset
        return node
    }
    
    /// Calculates an offset from the center of the parent label node.
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
