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

class GameSceneStatePause: GKState {
    
    unowned let scene : GameScene
    let pauseView: UIView
    
    init(scene: GameScene) {
        self.scene = scene
        
        pauseView = UIView(frame: scene.frame)
        pauseView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        pauseView.layer.position.y += scene.frame.height / 2
        pauseView.layer.position.x += scene.frame.width / 2
        let pauseLabel = UILabel(frame: CGRect(origin: CGPoint(x: scene.frame.midX, y: scene.frame.midY), size: CGSize(width: 300, height: 100)))
        pauseLabel.font = UIFont.systemFont(ofSize: 36)
        pauseLabel.textAlignment = .center
        pauseLabel.textColor = .black
        pauseLabel.text = "PAUSED"
        pauseLabel.frame.origin.x -= pauseLabel.frame.width * 0.5
        pauseLabel.frame.origin.y -= pauseLabel.frame.height * 0.5
        pauseView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2, 2, 1)
//        pauseView.addSubview(pauseLabel)
        
        
        let unpauseButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        unpauseButton.layer.position = CGPoint(x: pauseView.layer.frame.midX, y: pauseView.layer.frame.midY)
        unpauseButton.setTitle("UNPAUSE", for: .normal)
        pauseView.addSubview(unpauseButton)

        super.init()
        unpauseButton.addTarget(self, action: #selector(log(gestureRecognizer:)), for: .allEvents)
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
