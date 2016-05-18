//
//  GameScene.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright (c) 2016 phillipviau. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate { // add SKPhysicsContactDelegate for collision
    
    var collider = SKSpriteNode?()
    var objectsToRemove = [SKNode]()
    private var doubleTap : UITapGestureRecognizer! = nil
    private var upgradeProjectileTap : UITapGestureRecognizer! = nil
    
    
    override func didMoveToView(view: SKView) {
        
        physicsWorld.contactDelegate = self // instantiates contactDelegate to self
        gameScene = self
        self.backgroundColor = UIColor.blackColor()
        
        spawnCollider()
        spawnedPlayer = spawnPlayer()
        bgSetup = setupBg()
        spawnScoreLabel()
        spawnMainLabel()
        spawnHealthLabel()
        spawnedPlayer!.fireProjectile()
        resetVariablesOnStart()
        randomEnemyTimerSpawn()
        spawnLevelLabel()
        updateScore()
        hideLabel()
        setupLayers()
        
        doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 3
        upgradeProjectileTap = UITapGestureRecognizer(target: self, action: #selector(upgrade))
        upgradeProjectileTap.numberOfTapsRequired = 10
        view.addGestureRecognizer(upgradeProjectileTap)
        view.addGestureRecognizer(doubleTap)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            if isAlive {
                touching = true
            }
        }
        
        
    }
    
    func doubleTapped() {

        (self.view?.paused != false) ? (self.view?.paused = false) : (self.view?.paused = true) // Pauses game if not paused, unpauses game if paused

    }
    
    func upgrade () {
        spawnedPlayer.projectileLevel += 1
        print("Upgrade Complete")
        
    }
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches{
            let touchLocation = touch.locationInNode(self)
            //locationLabel.text = "X: \(spawnedPlayer!.position.x) Y: \(spawnedPlayer!.position.y)"
            
            
            playerOffsetX = spawnedPlayer!.position.x - touchLocation.x
            
            if isAlive {
                
                
                
                
                if touchLocation.x <= 320 && touchLocation.y <= 20 {
                    
                    spawnedPlayer?.position.x = 320
                    spawnedPlayer?.position.y = 20
                    
                }else if touchLocation.x >= frame.width - 324 && touchLocation.y <= 20 {
                    
                    spawnedPlayer?.position.x = frame.width - 324
                    spawnedPlayer?.position.y = 20
                    
                }else if touchLocation.x <= 320 {
                    spawnedPlayer?.position.x = 320
                    spawnedPlayer?.position.y = touchLocation.y
                }else if touchLocation.y <= 20 {
                    spawnedPlayer?.position.x = touchLocation.x
                    spawnedPlayer?.position.y = 20
                }else if touchLocation.x >= frame.width - 324  {
                    spawnedPlayer?.position.x = frame.width - 324
                    spawnedPlayer?.position.y = touchLocation.y
                    
                }else{
                    spawnedPlayer?.position.x = touchLocation.x
                    spawnedPlayer?.position.y = touchLocation.y
                }
                
                
            }
            
            if !isAlive {
                touching = false
                spawnedPlayer?.position.x = -200 // moves offscreen for performance if player dies
            }
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if !isAlive {
            touching = false
            spawnedPlayer?.position.x = -200 // moves offscreen for performance if player dies
            
        }
        
    }
    
    func setupLayers() {
        
        objectsLayer = SKSpriteNode()
        objectsLayer.name = "Objects Layer"
        addChild(objectsLayer)
    }
    
    func spawnCollider(){
        collider = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: self.frame.width, height: 10))
        collider?.position = CGPoint(x: CGRectGetMidX(self.frame), y: -9)
        collider?.physicsBody = SKPhysicsBody(rectangleOfSize: (collider?.size)!)
        collider?.physicsBody?.affectedByGravity = false
        collider?.physicsBody?.categoryBitMask = bitMasks.collider
        collider?.physicsBody?.collisionBitMask = 0
        collider?.physicsBody?.contactTestBitMask = bitMasks.enemy
        collider?.physicsBody?.dynamic = false
        self.addChild(collider!)
        
        
    }
    
    func spawnPlayer() -> player{
        let newPlayer = player()
        self.addChild(newPlayer) // adds player to scene as a child object to parent self
        
        return newPlayer
    }
    
    
    func spawnEnemy() -> enemy{
        
        let newEnemy = enemy()
        
        self.addChild(newEnemy)
        return newEnemy
        
    }
    
    func randomEnemyTimerSpawn(){
        let spawnEnemyTimer = SKAction.waitForDuration(enemy().getSpawnRate())
        let spawn = SKAction.runBlock{
            if isAlive && enemy().getShips() > 0 {
                spawnedEnemy = enemy()
                self.addChild(spawnedEnemy)
                enemy().destroyShip()
            }
            //            }else if isAlive && ships <= 0 {
            //                let wait = SKAction.waitForDuration(7.5)
            //                let run = SKAction.runBlock{
            //                    self.updateLevel()
            //                }
            //                let sequence = SKAction.sequence([wait, run])
            //                self.runAction(SKAction.repeatAction(sequence, count: 1 ))
            //                print("\(ships)")
            //            }
        }
        
        let wait = SKAction.waitForDuration(10)
        let reset = SKAction.runBlock{
            if enemy().getShips() < 1 {
                self.updateLevel()
                self.randomEnemyTimerSpawn()
            }
        }
        
        let sequence = SKAction.sequence([spawnEnemyTimer, spawn])
        let run = SKAction.repeatAction(sequence, count: enemy().getShips() )
        let run2 = SKAction.sequence([run, wait, reset])
        self.runAction(run2)
        //self.runAction(SKAction.repeatActionForever(run2))
        
    }
    
    
    
    func setupBg() -> starfield {
        let newBg = starfield()
        self.addChild(newBg)
        return newBg
    }
    
    func spawnScoreLabel(){
        scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = textColorHUD
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame) + 160, y: CGRectGetMaxY(self.frame) - 35)
        scoreLabel.text = "Score"
        self.addChild(scoreLabel)
        
        
    }
    
    func spawnLevelLabel(){
        levelLabel = SKLabelNode(fontNamed: "Futura")
        levelLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 35)
        levelLabel.fontColor = textColorHUD
        
        levelLabel.text = "\(level)"
        levelLabel.fontSize = 18
        levelLabel.zPosition = layers.projectiles
        self.addChild(levelLabel)
    }
    
    func spawnHealthLabel(){
        playerHealthLabel = SKLabelNode(fontNamed: "Futura")
        playerHealthLabel.position = CGPoint(x: CGRectGetMidX(self.frame) - 160, y: CGRectGetMaxY(self.frame) - 35)
        playerHealthLabel.fontColor = textColorHUD
        playerHealthLabel.text = "HP: \(spawnedPlayer!.health)"
        playerHealthLabel.fontSize = 18
        playerHealthLabel.zPosition = layers.projectiles
        self.addChild(playerHealthLabel)
        
    }
    
    func spawnMainLabel(){
        mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel?.fontSize = 100
        mainLabel?.fontColor = textColorHUD
        mainLabel?.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        mainLabel?.text = "Start"
        
        self.addChild(mainLabel!)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) { // collision detection function
        
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask // Assigns contactMask with two UInt32 assignments for comparison in switch statement
        
        switch (contactMask){
        case bitMasks.enemy | bitMasks.player: // contact.bodyB.categoryBitMask | contact.bodyA.categoryBitMask
            
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                //test = test + 1
                //print("Contact Made Player Enemy")
                enemyPlayerCollision(contact.bodyB.node as! SKSpriteNode, playerTemp: contact.bodyA.node as! SKSpriteNode)
            }
            break
        case bitMasks.projectile | bitMasks.enemy:
            //print("\(contactMask)")
            if contact.bodyA.node != nil && contact.bodyB.node != nil {
                projectileCollision(contact.bodyA.node as! SKSpriteNode, projectileTemp: contact.bodyB.node! as! SKSpriteNode)
            }
            break
        case bitMasks.projectileEnemy | bitMasks.player:
            print("Enemy shot player")
            if contact.bodyA.node != nil && contact.bodyB.node != nil && contact.bodyA.categoryBitMask == bitMasks.player {
                enemyPlayerCollision(contact.bodyB.node as! SKSpriteNode, playerTemp: contact.bodyA.node as! SKSpriteNode)
            }
            break
            /*case bitMasks.collider | bitMasks.enemy:
             print("\(bitMasks.enemy) \(bitMasks.collider)")
             print("\(contact.bodyB.categoryBitMask) \(contact.bodyA.categoryBitMask)")
             if contact.bodyA.node != nil && contact.bodyB.node != nil && contact.bodyA.categoryBitMask == bitMasks.collider {
             //if(contact.bodyA.categoryBitMask == bitMasks.enemy) {
             print("Enemy got past youA")
             enemyColliderCollision(contact.bodyA.node as! SKSpriteNode, colliderTemp: contact.bodyB.node as! SKSpriteNode)
             //}
             }
             break*/
        default:
            break
            //return
            
        }
        
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        
    }
    
    func projectileCollision(enemyTemp: SKSpriteNode, projectileTemp: SKSpriteNode){
        
        projectileTemp.removeFromParent() // removes passed object from scene
        spawnedEnemy.takeDamage(spawnedPlayer.damage)
        print("enemyTemp: \(spawnedEnemy.health)")
        //print("Spawned Enemy Health: \(spawnedEnemy.health)")
        if(spawnedEnemy.health <= 0) {
            spawnExplosionEmitter(projectileTemp) // runs function passing enemyTemp SKSpriteNode for removal following action
            enemyTemp.removeFromParent()
            
            score += 1 // increases score
            updateScore() // updates score label
        }
    }
    
    func enemyPlayerCollision(enemyTemp: SKSpriteNode, playerTemp: SKSpriteNode){
        
        spawnExplosionEmitter(enemyTemp)
        spawnedPlayer.takeDamage(Float(spawnedEnemy.damage))
        if spawnedPlayer.health <= 0 { // checks if player health is below dead
            
            playerTemp.removeFromParent() // removes player sprite from scene
            isAlive = false                 // assigns isAlive bool to false
            waitThenMoveToTitleScreen()     // runs function to move to new screen
        }
        enemyTemp.removeFromParent()
        updateHealth()
    }
    
    func spawnExplosionEmitter(enemyTemp: SKSpriteNode) {
        let explosionEmitterPath : NSString = NSBundle.mainBundle().pathForResource("explosion", ofType: "sks")!
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionEmitterPath as String) as! SKEmitterNode
        
        explosion.position = CGPoint(x: enemyTemp.position.x, y: enemyTemp.position.y)
        explosion.zPosition = 1
        explosion.targetNode = self
        
        self.addChild(explosion)
        
        let explosionTimerRemove = SKAction.waitForDuration(0.45)
        let removeExplosion = SKAction.runBlock{
            explosion.removeFromParent()
            
        }
        
        //enemyTemp.removeFromParent()
        
        self.runAction(SKAction.sequence([explosionTimerRemove, removeExplosion]))
        
    }
    
    func enemyColliderCollision(enemyTemp: SKSpriteNode, colliderTemp: SKSpriteNode){
        
        
        enemyTemp.removeFromParent()
        spawnedPlayer.takeDamage(5)
        if spawnedPlayer.health <= 0 {
            spawnedPlayer.removeFromParent()
            
            isAlive = false
            
            waitThenMoveToTitleScreen()
        }
        
    }
    
    
    
    func waitThenMoveToTitleScreen(){
        
        let wait = SKAction.waitForDuration(3.0)
        let transition = SKAction.runBlock{
            self.view?.presentScene(TitleScene(), transition: SKTransition.crossFadeWithDuration(1.25))
        }
        
        let sequence = SKAction.sequence([wait, transition, wait])
        
        self.runAction(SKAction.repeatAction(sequence, count: 1))
        
    }
    
    func updateHealth(){
        (player().health > 0) ? (playerHealthLabel.text = "HP: \(spawnedPlayer.health)") : (playerHealthLabel.text = "HP: 0")
        
    }
    
    func updateScore(){
        
        scoreLabel.text = "Score \(score)"
        
    }
    
    func updateLevel(){
        //(level <= (Int(Double(score) / (5 + Double(level) + 1)))) ? (level = (Int(score / (5 + level + 1)))) : (level >= (Int(Double(score) / (5 + Double(level) + 1)))) ? enemy().setShips(50) : (level = level)
        level += 1
        switch(difficultySet){
        case 1:
            enemy().setShip((Int(Float(level + shipAdd[difficultySet - 1]) * (Float(difficultySet) / 2))))
            break
        case 2:
            enemy().setShip((Int(Float(level + shipAdd[difficultySet - 1]) * (Float(difficultySet) / 2))))
            break
        case 3:
            enemy().setShip((Int(Float(level + shipAdd[difficultySet - 1]) * (Float(difficultySet) / 2))))
            break
        case 4:
            enemy().setShip((Int(Float(level + shipAdd[difficultySet - 1]) * (Float(difficultySet) / 2))))
            break
        case 5:
            enemy().setShip((Int(Float(level + shipAdd[difficultySet - 1]) * (Float(difficultySet) / 2))))
            break
        default:
            break
        }
        
        print("Level Up \(enemy().getShips())")
        //}
        levelLabel.text = "\(level)"
    }
    
    
    func hideLabel(){
        let wait = SKAction.waitForDuration(3.0)
        let hide = SKAction.runBlock{
            mainLabel?.alpha = 0.0
        }
        
        let sequence = SKAction.sequence([wait, hide])
        self.runAction(SKAction.repeatAction(sequence, count: 1))
        
    }
    
    func resetVariablesOnStart(){ // function to reset variables back to default
        isAlive = true
        score = 0
        //ships = 5
        //spawnedPlayer.totalShips = 3
        level = 1
        
    }
    
    
    
}

