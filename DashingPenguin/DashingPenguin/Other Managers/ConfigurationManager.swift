//
//  ConfigurationManager.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 4/12/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import UIKit

class ConfigurationManager {
    let sharedInstance = ConfigurationManager()
    
    init() {
        
    }
    
    func screenRatio() -> CGFloat {
        let b = UIScreen.main.bounds
        return b.height / b.width
    }
}
