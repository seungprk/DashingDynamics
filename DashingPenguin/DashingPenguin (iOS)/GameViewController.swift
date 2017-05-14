//
//  GameViewController.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 7/3/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

//    var skView: SKView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView

        if !FormFactor.isIPhone {
            let frame = self.view.frame
            let width = frame.height / (16 / 9)
            let insetX = (self.view.frame.width - width) / 2
            skView.frame = frame.insetBy(dx: insetX, dy: 0)
        }

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        skView.showsFields = true

        // Lower resolution to pixelate game scenes
        let downscaleRatio = 180 / skView.frame.width
        let downscaledHeight = skView.frame.height * downscaleRatio
        let downscaledSize = CGSize(
            width: 180,
            height: downscaledHeight
        )
        let scene = MenuScene(size: downscaledSize)
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }  
    }  
    
}
