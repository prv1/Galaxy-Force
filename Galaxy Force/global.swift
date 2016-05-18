//
//  global.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import Foundation
import SpriteKit

var scoreLabel = SKLabelNode()
var levelLabel = SKLabelNode()
var mainLabel = SKLabelNode?()
var playerHealthLabel = SKLabelNode(text: "HP: 100")

var locationLabel = SKLabelNode()

//var ships = 5
var shipAdd : [Int] = [2, 3, 5, 8, 11]
var enemySpawnRate = 0.75

var isAlive = true
var touching = false
var isTopScrolliingLevel = true

var score = 0
var level : Int = 1
var wave : Int = 1

var textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)


var difficulty : [Int] = [1, 2, 3, 4, 5]
var difficultySet : Int = 3

var playerOffsetX : CGFloat = 0.0

let texturesDefault = SKTexture(imageNamed: "empty")
let texturesPlayer = SKTexture(imageNamed: "playerBlue")
let texturesEnemy = SKTexture(imageNamed: "enemy")

let texturesBullet1 = SKTexture(imageNamed: "Bullet")
let texturesBullet2 = SKTexture(imageNamed: "Bullet")

let texturesBg = SKTexture(imageNamed: "bg")

let scale: CGFloat = 1.0

struct layers {
    
    static let background: CGFloat = -10
    static let characters: CGFloat = 2
    static let projectiles: CGFloat = -1
    
}

struct bitMasks {
    
    // Bit Masks
    static let player: UInt32 = 0x1 << 0
    static let enemy: UInt32 = 0x1 << 1
    static let projectile: UInt32 = 0x1 << 2
    static let projectileEnemy: UInt32 = 0x1 << 3
    static let noContact: UInt32 = 0x1 << 4
    static let collider: UInt32 = 0x1 << 5
}



// Constants
var gameScene: SKScene!
let screenH = UIScreen.mainScreen().bounds.size.height
let screenW = UIScreen.mainScreen().bounds.size.width
var frameW = gameScene.frame.size.width
var frameH = gameScene.frame.size.height

var spawnedPlayer: player!
var spawnedEnemy: enemy!
var bgSetup : starfield!

var nodesToRemove = [SKSpriteNode]()
var objectsLayer: SKSpriteNode!

func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}

func randomIntBetweenNumbers(firstNum: Int, secondNum: Int) -> Int{
    return firstNum + Int(arc4random_uniform(UInt32(secondNum - firstNum + 1)))
}

// COLORS

let blueColor = SKColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1)
let whiteColor = SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
let greenColor = SKColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1)
let redColor = SKColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1)