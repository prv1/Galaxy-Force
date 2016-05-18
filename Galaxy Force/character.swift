//
//  character.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import UIKit
import SpriteKit

class character: SKSpriteNode {
    
    internal var health : Float = 10.0
    var damage : Float = 1.0
    internal var totalShips : Int = 1
    //internal var ships = 1
    
    init() {
        let texture = texturesDefault
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size()) // required for SKSpriteNode class
        //ships = 1
    }
    
    deinit{}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func die() {
        isAlive = false
        //self.removeFromParent()
    }
    
}