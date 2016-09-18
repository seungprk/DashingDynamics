//
//  GameScene+SKButtonDelegate.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/17/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

extension GameScene: SKButtonDelegate {
    func onButtonPress(type: SKButtonType) {
        switch type {
        case .pause:
            guard let currentState = stateMachine.currentState else { return }
            if type(of: currentState) is GameSceneStatePause.Type {
                stateMachine.enter(GameSceneStatePlaying.self)
            }
            else {
                stateMachine.enter(GameSceneStatePause.self)
            }
            
        }
    }
}
