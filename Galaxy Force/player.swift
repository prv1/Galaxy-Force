//
//  player.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import UIKit
import SpriteKit

class player: character,pTargetable {
    
    
    var weapon: pWeapon
    var projectileType : [String] = ["Bullet", "Double", "Laser", "Spread", "Twist"]
    var playerPowerUp : [String] = ["None", "Missile", "Homing", "Conucussive", "Spiral"]
    var projectileLevel = 0
    var powerUpLevel = 0
    var projectileDamage : [Float] = [1.0, 2.0, 3.5, 2.25, 1.50]
    var powerUpDamage : [Float] = [0.0, 5.0, 5.0, 7.0, 9.0]
    var fireProjectileRate : [Float] = [0.21, 0.45, 0.15, 0.37, 0.72]
    var projectileSpeed : [Float] = [0.18, 0.45, 0.32, 0.40, 0.57]
    var baseDamage : Float = 5.0
    
    override init() {
        
        self.weapon = Gun()  // initializing the default weapon for our Hero
        
        super.init()   //  initialize the default values from the SuperClass ( character )
        health = Float(450 / difficultySet)
        totalShips = 3
        damage = baseDamage * projectileDamage[projectileLevel]
        let texture = texturesPlayer
        let xSize = texture.size().width*scale                // Create The texture for the top ( visible sprite )
        let ySize = texture.size().height*scale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.dynamic = false
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 1.0
        self.name = "player"
        
        // COLLISION STUFF
        self.physicsBody?.categoryBitMask = bitMasks.player // ship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = bitMasks.enemy
        
        let top = SKSpriteNode(texture: texture, size: size)
        
        top.zPosition = layers.characters
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite
        self.addChild(top)
        //shoot()
        
    }
    
    deinit{}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func takeDamage(damage: Float) {
        health -= damage
        print("You lost \(damage) hit points, life left: \(health)")
        
        if health <= 0 {
            print("You are dead now")
            
        }
    }
    
    func shoot() {
        
        let newBullet = bulletPlayer()
        newBullet.physicsBody?.categoryBitMask = bitMasks.projectile  // ship
        newBullet.physicsBody?.contactTestBitMask = bitMasks.enemy
        newBullet.position = CGPoint(x: self.position.x + 10, y: self.position.y)
        let moveForward = SKAction.moveToY(800, duration: Double(projectileSpeed[projectileLevel]))
        let force = SKAction.applyForce(CGVector(dx: 0, dy: 1200), duration: 2.5)
        let destroy = SKAction.removeFromParent()
        //newBullet.physicsBody?.velocity = CGVector(dx: 0, dy: (Int(arc4random_uniform(25)) + 12250))
        newBullet.runAction(SKAction.sequence([moveForward, force, destroy]))
        objectsLayer.addChild(newBullet)
        
    }
    
    
    func fireProjectile(){
        let fireProjectileTimer = SKAction.waitForDuration(Double(fireProjectileRate[projectileLevel]))
        let spawn = SKAction.runBlock{
            if touching {
                self.shoot()
            }
        }
        
        let sequence = SKAction.sequence([fireProjectileTimer, spawn])
        self.runAction(SKAction.repeatActionForever(sequence))
        
    }
    
}