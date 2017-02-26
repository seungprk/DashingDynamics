//
//  GameSceneStatePause.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/11/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import QuartzCore

class GameSceneStatePause: GKState {
    
    unowned let scene : GameScene
    let pauseView: UIView
    
    init(scene: GameScene) {
        self.scene = scene
        
        // Pause View
        pauseView = UIView(frame: scene.frame)
        pauseView.backgroundColor = .clear
        pauseView.layer.position.y += scene.frame.height / 2 + 20
        pauseView.layer.position.x += scene.frame.width / 2 + 20
        pauseView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.5, 2.5, 1)
        super.init()
        
        // Background Blur
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = pauseView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Unpause Button
        // Sprite image size: 41 x 21
        let buttonSize = CGRect(x: 0, y: 0, width: 41 * 4, height: 21 * 4)
        let unpauseButton = UIButton(frame: buttonSize)
        unpauseButton.layer.position = CGPoint(
            x: pauseView.layer.frame.midX - 105,
            y: pauseView.layer.frame.midY - 180)
        unpauseButton.setImage(UIImage(named: "unpause-button"), for: .normal)
        unpauseButton.imageView?.layer.magnificationFilter = kCAFilterNearest
        unpauseButton.addTarget(self, action: #selector(log(gestureRecognizer:)), for: .allEvents)
        
        pauseView.addSubview(blurEffectView)
        pauseView.addSubview(unpauseButton)
    }
    
    func log(gestureRecognizer: UIGestureRecognizer) {
        scene.stateMachine.enter(GameSceneStatePlaying.self)
        print("hello~ from pause scene")
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.view?.addSubview(pauseView)
        scene.view?.isPaused = true
    }
    
    override func willExit(to nextState: GKState) {
        pauseView.removeFromSuperview()
        scene.view?.isPaused = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
}

extension GameSceneStatePause: SKButtonDelegate {
    func onButtonPress(named: String) {
        print(named)
    }
}
