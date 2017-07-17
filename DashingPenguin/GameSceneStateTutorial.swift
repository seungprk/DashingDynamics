//
//  GameSceneStateTutorial.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/16/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TapDelegate {
    func tapGesture(at location: CGPoint)
}

func scaleImage(image: UIImage) -> UIImage {
    return UIImage(
        cgImage: image.cgImage!,
        scale: 0.25,
        orientation: UIImageOrientation.up
    )
}

class GameSceneStateTutorial: GKState, TapDelegate {
    
    unowned let scene: GameScene
    var slideView: UIImageView
    
    let slides: [UIImage] = {
        let images = [
            UIImage(named: "1.png")!,
            UIImage(named: "2.png")!,
            UIImage(named: "3.png")!
        ]
        
        return images.map(scaleImage)
    }()
 
    init(scene: GameScene) {
        self.scene = scene
        self.slideView = UIImageView(image: nil)
        super.init()
        
        self.slideView.contentMode = .scaleAspectFit
        self.slideView.layer.magnificationFilter = kCAFilterNearest
        setSlide(image: slides.first!)
    }
    
    override func didEnter(from previousState: GKState?) {
        scene.view?.addSubview(slideView)
        scene.view?.isPaused = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneStatePlaying.Type
    }
    
    func tapGesture(at location: CGPoint) {
        if slideView.image == slides.last! {
            scene.stateMachine.enter(GameSceneStatePlaying.self)
        } else {
            nextSlide()
        }
    }
    
    func setSlide(image: UIImage) {
        let center = CGPoint(
            x: scene.view!.frame.width / 2 - image.size.width / 2,
            y: scene.view!.frame.height / 2 - image.size.height / 2
        )

        slideView.image = image
        slideView.frame = CGRect(origin: center, size: image.size)
    }
    
    func nextSlide() {
        var current: Any?
        for slide in slides {
            if current != nil {
                setSlide(image: slide)
                break
            }
            if slideView.image == slide {
                current = slide
            }
        }
    }
    
    override func willExit(to nextState: GKState) {
        slideView.removeFromSuperview()
        scene.view?.isPaused = false
    }
}
