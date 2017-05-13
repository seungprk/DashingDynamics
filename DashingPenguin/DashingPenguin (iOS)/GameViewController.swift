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
        skView.showsPhysics = true
        skView.ignoresSiblingOrder = true
        skView.showsFields = true
        
        print(skView.frame)
        skView.frame = CGRect(
            x: skView.frame.origin.x - 10,
            y: skView.frame.origin.y - 10,
            width: skView.frame.width + 20,
            height: skView.frame.height + 20
        )
        print(skView.frame)

        // Lower resolution to pixelate game scenes
        let downscaleRatio = 180 / skView.frame.width
        let downscaledHeight = skView.frame.height * downscaleRatio
        let downscaledSize = CGSize(
            width: 180, //FormFactor.isIPhone ? 180 : 120,
            height: downscaledHeight
        )
        let scene = MenuScene(size: downscaledSize)
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
