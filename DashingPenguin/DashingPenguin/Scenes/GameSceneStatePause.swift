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
        let scale = scene.view!.frame.width / 180
        pauseView.layer.frame = CGRect(
            x: scene.view!.frame.origin.x,
            y: scene.view!.frame.origin.y,
            width: scene.view!.frame.width / scale,
            height: scene.view!.frame.height / scale)
        let viewX = scene.view!.frame.midX
        let viewY = scene.view!.frame.midY
        pauseView.layer.position.x = viewX
        pauseView.layer.position.y = viewY
        super.init()
        
        // Background Blur
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = pauseView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Unpause Button
        // Sprite image size: 41 x 21
        let buttonSize = CGRect(x: 0, y: 0, width: 41, height: 21)
        let unpauseButton = UIButton(frame: buttonSize)
        unpauseButton.frame.origin = CGPoint(
            x: pauseView.frame.size.width / 2 - unpauseButton.frame.size.width / 2,
            y: pauseView.frame.size.height / 2 - unpauseButton.frame.size.height / 2)
        let buttonImage = UIImage(named: "unpause-button")
        unpauseButton.setImage(buttonImage, for: .normal)
        unpauseButton.imageView?.layer.magnificationFilter = kCAFilterNearest
        unpauseButton.addTarget(self, action: #selector(log(gestureRecognizer:)), for: .allEvents)
        pauseView.addSubview(blurEffectView)
        pauseView.addSubview(unpauseButton)
        
        
        pauseView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func log(gestureRecognizer: UIGestureRecognizer) {
        scene.stateMachine.enter(GameSceneStatePlaying.self)
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
