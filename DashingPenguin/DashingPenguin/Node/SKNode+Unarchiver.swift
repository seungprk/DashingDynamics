//
//  SKNode+Unarchiver.swift
//  DashingPenguin
//
//  Created by Matthew Tso on 9/15/16.
//  Copyright © 2016 Dashing Duo. All rights reserved.
//

import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file: String) -> SKNode? {
        
        guard let path = Bundle.main.path(forResource: file, ofType: "sks") else { return nil }
        let url = URL(fileURLWithPath: path)
        
        var nodeData: Data
        do {
            try nodeData = Data(contentsOf: url, options: .mappedIfSafe)
        } catch {
            print(error)
            return nil
        }
        
        let archiver = NSKeyedUnarchiver(forReadingWith: nodeData)
        archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKNode")
        
        let node = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKNode
        archiver.finishDecoding()
        return node
    }
}
