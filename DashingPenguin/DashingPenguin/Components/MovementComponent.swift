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
        initialStateClass = initialState.dynamicType
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(withDeltaTime seconds: TimeInterval) {
        super.update(withDeltaTime: seconds)
        
        stateMachine.update(withDeltaTime: seconds)        
    }
    
    func enterInitialState() {
        stateMachine.enterState(initialStateClass)
    }
    
    func dash(_ velocity: CGVector) {
        self.velocity = velocity
        stateMachine.enterState(DashingState.self)
    }
}
