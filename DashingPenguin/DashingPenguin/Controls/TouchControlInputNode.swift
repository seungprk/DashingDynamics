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
        super.init(texture: nil, color: UIColor.red(), size: frame.size)
        
        print(frame)
        
        zPosition = 10000
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        
        let touch = touches.first!
        
        startLocation = touch.location(in: self)
        startTime = touch.timestamp
        
        print("swiping...", terminator: "")

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let endLocation = touch.location(in: self)
        
        let dx = endLocation.x - startLocation.x
        let dy = endLocation.y - startLocation.y
        let magnitude = sqrt(dx * dx + dy * dy)
        
        if magnitude >= GameplayConfiguration.TouchControls.minDistance {
            let dt = touch.timestamp - startTime
//            if dt > GameplayConfiguration.TouchControls.minDuration {
            
                let speed = Double(magnitude) / dt
//                if speed >= GameplayConfiguration.TouchControls.minSpeed && speed <= GameplayConfiguration.TouchControls.maxSpeed {
                
                    let direction = CGVector(dx: dx / magnitude, dy: dy / magnitude)
                    print(direction)
//                }
//            }
        } else {
            
            print(magnitude)
            delegate?.tapGesture(at: endLocation)
        }
    }
}
