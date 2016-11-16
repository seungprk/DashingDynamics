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

    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsPhysics = false
        skView.ignoresSiblingOrder = true
        
        // Lower resolution to pixelate game scenes
        let downscaleRatio = 180 / skView.frame.width
        let downscaledHeight = skView.frame.height * downscaleRatio
        let downscaledSize = CGSize(width: 180, height: downscaledHeight)
        let scene = MenuScene(size: downscaledSize) // GameScene(size: skView.frame.size)
        scene.scaleMode = .aspectFill
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
