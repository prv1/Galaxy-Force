//
//  TitleScene.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import SpriteKit

class TitleScene : SKScene {
    
    private var btnPlay : UIButton!
    private var gameTitle : UILabel!
    private var slider : UISlider!
    private var difficultyLabel : UILabel!
    private var difficultyText : UILabel!
    private var textColorHUD = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    override func didMoveToView(view: SKView){
        self.backgroundColor = UIColor.blackColor()
        
        setupText()
        
    }
    
    
    func setupText(){
        btnPlay = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
        btnPlay.center = CGPoint(x: view!.frame.size.width / 2, y: 600)
        btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 60)
        btnPlay.setTitle("Play", forState: UIControlState.Normal)
        btnPlay.setTitleColor(textColorHUD, forState: UIControlState.Normal)
        btnPlay.addTarget(self, action: #selector(TitleScene.playTheGame), forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(btnPlay)
        
        
        slider = UISlider(frame: CGRect(x:0, y:250, width: view!.frame.width * 4/5, height: 20))
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.value = Float(difficultySet)
        slider.backgroundColor = UIColor.clearColor()
        slider.tintColor = UIColor.blueColor()
        slider.addTarget(self, action: #selector(TitleScene.sliderValueDidChange(_:)), forControlEvents: .ValueChanged)
        slider.center = CGPoint(x: view!.frame.size.width / 2, y: 400)
        
        difficultyText = UILabel(frame: CGRect(x:0, y:340, width: view!.frame.width, height: 40))
        difficultyText!.textColor = textColorHUD
        difficultyText!.font = UIFont(name: "Futura", size: 20)
        difficultyText!.textAlignment = NSTextAlignment.Center
        difficultyText!.text = "For the average player"
        
        difficultyLabel = UILabel(frame: CGRect(x:0, y:425, width: view!.frame.width, height: 20))
        difficultyLabel!.textColor = textColorHUD
        difficultyLabel!.font = UIFont(name: "Futura", size: 20)
        difficultyLabel!.textAlignment = NSTextAlignment.Center
        difficultyLabel!.text = "Level 3"
        
        gameTitle = UILabel(frame: CGRect(x:0, y:0, width: view!.frame.width, height: 300))
        
        gameTitle!.textColor = textColorHUD
        gameTitle!.font = UIFont(name: "Futura", size: 60)
        gameTitle!.textAlignment = NSTextAlignment.Center
        gameTitle!.text = "Galaxy Force"
        self.view?.addSubview(difficultyLabel)
        self.view?.addSubview(difficultyText)
        self.view?.addSubview(gameTitle)
        self.view?.addSubview(slider)
        
    }
    
    func sliderValueDidChange(sender:UISlider!){
        let diff = Int(sender.value)
        difficultySet = diff
        difficultyLabel.text = "Level \(difficultySet)"
        switch(difficultySet){
        case 1:
            difficultyText.text = "Come On Nick Really!!!"
        case 2:
            difficultyText.text = "Walkin' on sunshine"
        case 4:
            difficultyText.text = "Its smokin' now"
        case 5:
            difficultyText.text = "You'll be on fire, literally!"
        default:
            difficultyText.text = "For the average player"
            
        }
        
    }
    
    
    func playTheGame(){
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFadeWithDuration(1.0))
        btnPlay.removeFromSuperview()
        gameTitle.removeFromSuperview()
        difficultyLabel.removeFromSuperview()
        difficultyText.removeFromSuperview()
        slider.removeFromSuperview()
        
        if let scene = GameScene(fileNamed: "GameScene"){
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            
            scene.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
        
    }
    
    
}
