//
//  projectile.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import UIKit
import SpriteKit

class projectile: SKSpriteNode {
    
    init() {
        let texture = texturesDefault
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())   //
    }
    
    deinit{}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTop(withTexture: SKTexture) {                           // Function for adding the visible texture
        
        let xSize = withTexture.size().width*scale                  // Define xSize based on parameter withTexture
        let ySize = withTexture.size().height*scale                 // Define ySize based on parameter withTexture
        let size = CGSize(width: xSize, height: ySize)              // Creates CGSize object
        let top = SKSpriteNode(texture: withTexture, size: size)    // Assigns SKSpriteNode based on parameters
        top.zPosition = layers.projectiles                          // Adds position to object
        self.addChild(top)                                          // add object to scene
    }
}

class bulletEnemy: projectile {
    
    var ptexture: SKTexture!
    
    override init() {
        super.init()
        let enemyProjectile = texturesBullet1
        self.name = "projectileEnemy"
        self.physicsBody = SKPhysicsBody(texture: enemyProjectile, size: enemyProjectile.size())
        self.physicsBody?.categoryBitMask = bitMasks.projectileEnemy // ship Actual physicsbody
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = bitMasks.player
        self.addTop(enemyProjectile)
    }
    
    deinit{}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class bulletPlayer: projectile {
    
    var ptexture: SKTexture!
    
    override init() {
        super.init()
        let top = SKTexture(imageNamed: spawnedPlayer.projectileType[spawnedPlayer.projectileLevel])
        self.physicsBody = SKPhysicsBody(texture: top, size: top.size())
        self.name = "projectile"
        self.physicsBody?.categoryBitMask = bitMasks.projectile  // ship
        self.physicsBody?.contactTestBitMask = bitMasks.enemy
        self.physicsBody?.collisionBitMask = 0
        self.addTop(top)
        
    }
    
    deinit{}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
