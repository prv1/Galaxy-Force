//
//  starfield.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import Foundation
import SpriteKit

class starfield : SKSpriteNode {
    
    init() {
        
        let texture = SKTexture(imageNamed: "starBg")
        super.init(texture: texturesDefault, color: SKColor.clearColor(), size: texture.size()) // required for SKSpriteNode class
        
        for i in 0 ... 1 {
            let background = SKSpriteNode(texture: texture)
            background.zPosition = -30
            background.anchorPoint = CGPointZero
            background.position = CGPoint(x: 0, y: (texture.size().height * CGFloat(i)) - CGFloat(1 * i))
            addChild(background)
        }
        
        let moveDown = SKAction.moveByX(0, y: -texture.size().height, duration: 20)
        let moveReset = SKAction.moveByX(0, y: texture.size().height, duration: 0)
        let moveLoop = SKAction.sequence([moveDown, moveReset])
        let moveForever = SKAction.repeatActionForever(moveLoop)
        
        self.runAction(moveForever)
        
    }
    
    deinit{}
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}