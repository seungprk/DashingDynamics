//
//  TouchControlInputNode.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

protocol GameInputDelegate: class {
    
    func swipeGesture(velocity: CGVector)
    func tapGesture(at location: CGPoint)
}

class TouchControlInputNode: SKSpriteNode {
    
    var startLocation: CGPoint!
    var startTime: TimeInterval!
    weak var delegate: GameInputDelegate?
    
    init(frame: CGRect) {
        let testColor = SKColor.init(red: 1, green: 0, blue: 0, alpha: 0.2)
        super.init(texture: nil, color: testColor, size: frame.size)
        
        zPosition = GameplayConfiguration.HeightOf.controlInputNode
        name      = GameplayConfiguration.NameOf.controlInputNode
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard touches.count == 1 else { return }
        
        let touch = touches.first!
        startTime = touch.timestamp
        
        if let scene = self.scene {
            let touchLocation = touch.location(in: scene.view)
            startLocation = CGPoint(x: touchLocation.x, y: scene.view!.frame.maxY - touchLocation.y)
            
            print("swiping...", terminator: "")
            print(startLocation)
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard touches.count == 1 else { return }
        
        if let scene = self.scene {
            let touchLocation = touches.first!.location(in: scene.view)
            let endLocation = CGPoint(x: touchLocation.x, y: scene.view!.frame.maxY - touchLocation.y)
            
            let dx = endLocation.x - startLocation.x
            let dy = endLocation.y - startLocation.y

            delegate?.swipeGesture(velocity: CGVector(dx: dx, dy: dy))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
