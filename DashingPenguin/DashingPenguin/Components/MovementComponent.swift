//
//  DashComponent.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
        
    let stateMachine: GKStateMachine
    let initialStateClass: AnyClass
    
    var dashCount = 0
    
    var dashVelocity: CGVector?
    
//    var swipeAngle: CGFloat?
    
    var needsVelocityUpdate = false
        
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        
        let initialState = states.first!
        initialStateClass = type(of: initialState)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        stateMachine.update(deltaTime: seconds)
    }
    
    func enterInitialState() {
        stateMachine.enter(initialStateClass)
    }
    
    func dash(_ velocity: CGVector) {
        // Calculate the angle fo the swipe
        let angle = atan2(velocity.dy, velocity.dx)
        
        // Hard-coded linear velocity
        let velocityFactor: CGFloat = 695
        let calculatedX = velocityFactor * cos(angle)
        let calculatedY = velocityFactor * sin(angle)
        
        // Set velocity as the result of multiplying swipe angle and dash distance
        self.dashVelocity = CGVector(dx: calculatedX, dy: calculatedY)

        stateMachine.enter(DashingState.self)
    }
}
