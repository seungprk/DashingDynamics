//
//  ConfigurationManager.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 4/12/17.
//  Copyright © 2017 Dashing Duo. All rights reserved.
//

import UIKit

enum FormFactor {
    case iPad
    case iPhone
    
    static var current: FormFactor {
        get {
            if UIDevice.current.model == "iPhone" {
                return FormFactor.iPhone
            } else {
                return FormFactor.iPad
            }
        }
    }
    
    static var isIPhone: Bool {
        get {
            return FormFactor.current == .iPhone
        }
    }
}
