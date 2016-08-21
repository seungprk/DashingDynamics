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
    var velocity: CGVector?
    
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
        self.velocity = velocity
        stateMachine.enter(DashingState.self)
    }
}
