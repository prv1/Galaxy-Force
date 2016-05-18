//
//  enemy.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import UIKit
import SpriteKit

class enemy: character,pTargetable {
    
    var enemySpeed = 4.24
    private static let enemySpawnRate = 0.75
    var enemyType : Int = 0
    var enemyBaseHealth : Float = 2.0
    var enemyTypes : [String] = ["Spawn", "Brute", "Mini-Boss", "Boss"]
    var enemyDamage : [Float] = [2, 4, 6, 9, 12]
    var enemyHealthMultiplier : [Float] = [1.0, 1.8, 2.9, 4.2, 5.8]
    var enemyDamageMultiplier : [Float] = [1.0, 1.2, 2.1, 3.6, 4.8]
    private static var ships : Int = 5
    private static var shipsSet : Bool = false
    
    override init() {
        
        super.init()   //  initialize the default values from the SuperClass ( character )
        
        // override any values here
        //totalShips = Int(level / (5 + level) + 1)
        health = enemyBaseHealth * enemyHealthMultiplier[difficultySet - 1]
        damage = enemyDamage[difficultySet - 1] * enemyDamageMultiplier[difficultySet - 1]
        let texture = texturesEnemy
        let xSize = texture.size().width*scale                // Create The texture for the top ( visible sprite )
        let ySize = texture.size().height*scale
        let size = CGSize(width: xSize, height: ySize)
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false            // ( physical body stuff )
        self.physicsBody?.mass = 1.0
        self.name = "enemy"
        self.physicsBody?.allowsRotation = false // prevents object from rotating when colliding with other physics object
        
        // COLLISION STUFF
        
        self.physicsBody?.categoryBitMask = bitMasks.enemy  // ship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = bitMasks.player// | bitMasks.projectile
        
        // Begin Random Placement of enemy ships
        self.position = CGPoint(x: Int(arc4random_uniform(390) + 320), y: 768)
        let moveForward = SKAction.moveToY(0, duration: enemySpeed)
        let destroy = SKAction.removeFromParent()
        self.runAction(SKAction.sequence([moveForward, destroy]))
        // End Random Placement of enemy ships
        
        let top = SKSpriteNode(texture: texture, size: size)
        
        top.zPosition = layers.characters
        top.color = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        top.colorBlendFactor = 1.0
        // add the top sprite
        self.addChild(top)
        //moveEnemy(50, who: self)
        
        let shooting: SKAction = shoot()
        
        switch(difficultySet) {
        case 1:
            break
        case 2:
            break
        case 3:
            self.runAction((shooting), withKey: "shoot")
            break
        case 4:
            self.runAction((shooting), withKey: "shoot")
            break
        case 5:
            self.runAction((shooting), withKey: "shoot")
            break
        default:
            break
        }
        
        
        
    }
    
    deinit{    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
        func getShips() -> Int {
            if enemy.ships > 0 {
            return enemy.ships
            }
            //enemy.shipsSet = false
            return 0
    
        }
    
    func setShip(ship : Int) {
        enemy.ships = ship
    }
    
        func destroyShip() {
            enemy.ships -= 1
            print("Ships: \(enemy.ships)")
        }
    
    func takeDamage(damage: Float) {
        health -= damage
        print("Enemy lost \(damage) hit points")
        
        if health <= 0 {
            print("Enemy is dead now")
            
        }
    }
    
    //    func returnShips () -> Bool {
    //        if self.ships > 0 {
    //            return true
    //        }
    //        return false
    //    }
    
    func moveEnemy(speed: CGFloat, who: enemy) {
        
        let path = CGPathCreateMutable() // create a path
        
        //CGPathMoveToPoint(path, nil, enemyPosition.x, enemyPosition.y) // starting position
        //CGPathAddLineToPoint(path, nil, enemyPosition.x, frameH-(texturesEnemy.size().height)*scale)  // first point is the full height minus half of enemy's height
        //CGPathAddLineToPoint(path, nil, enemyPosition.x, (texturesEnemy.size().height)*scale)  //second point
        //CGPathAddLineToPoint(path, nil, enemyPosition.x, enemyPosition.y) // starting position
        
        let followLine = SKAction.followPath(path, asOffset: false, orientToPath: false, speed: speed)
        let repeatingFollow = SKAction.repeatActionForever(followLine)
        
        who.runAction(repeatingFollow) // run the Action on the enemys
    }
    
    func moveTypeA() -> SKAction {
        let move = SKAction.runBlock{
            
        }
        return move
    }
    
    
    func shootingRepeater()-> SKAction {
        let shooting = SKAction.runBlock { () -> Void in
            let newBullet = bulletEnemy()
            newBullet.position = CGPoint(x: self.position.x , y: self.position.y)
            objectsLayer.addChild(newBullet)
            newBullet.physicsBody?.velocity = CGVector(dx: 0, dy: -250)
            newBullet.physicsBody?.affectedByGravity = false
            newBullet.physicsBody?.categoryBitMask = bitMasks.projectileEnemy
            newBullet.physicsBody?.collisionBitMask = 0
            newBullet.physicsBody?.contactTestBitMask = bitMasks.player
        }
        return shooting
    }
    
    func shoot() -> SKAction {
        
        let shootingDelay = SKAction.waitForDuration(2.3, withRange:2.0 )
        let rocketShootingSequence = SKAction.sequence([shootingRepeater(),shootingDelay])
        let shootingRepeatAction = SKAction.repeatActionForever(rocketShootingSequence)
        
        return shootingRepeatAction
    }
    
    func getSpawnRate() -> Double {
        return enemy.enemySpawnRate
    }
    
    
}