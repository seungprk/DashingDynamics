//
//  Platform.swift
//  DashingPenguin
//
//  Created by Seung Park on 7/10/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit
import GameplayKit

class Obstacle: GKEntity {
    
    let size = CGSize(width: 100, height: 100)
    
    override init() {
        super.init()
        
        let spriteComponent = SpriteComponent(color: UIColor.red(), size: self.size)
        addComponent(spriteComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
