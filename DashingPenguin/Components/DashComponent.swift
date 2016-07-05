//
//  DashComponent.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/5/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class DashComponent: GKComponent {
    
    let stateMachine: GKStateMachine
    
    let initialStateClass: AnyClass
    
    override init() {
        stateMachine = GKStateMachine(states: [
            ])
        initialStateClass = stateMachine.currentState! as! AnyClass
        
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
}
