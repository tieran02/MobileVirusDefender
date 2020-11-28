//
//  ResearchEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 23/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class ResearchEntity : BaseEntity
{
    var healthbar : UIProgressView?
    
    let PointGain : Int = 20
    let WaitTime : Float = 10
    var pointTimer : Float = 0
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 1000)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup()
    {
        super.setup()
        self.isUserInteractionEnabled = true
        MaxHealth = 1000
        Heal(amount: MaxHealth)
        
        Destructable = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsMask.Turret.rawValue
        
        //hide healthbar
        HealthBar.isHidden = true
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        super.Update(deltaTime: deltaTime, scene: scene)
        
        if(pointTimer >= WaitTime)
        {
            increaseResearch()
            pointTimer = 0
        }
        pointTimer += deltaTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let gameScene = scene as? GameScene
        {
            switch Int.random(in: 0...1) {
            case 0:
                gameScene.viewController?.loadPuzzleScene(sceneName: "TestTubePuzzleScene", completeDelegate: completePuzzle)
                break
            case 1:
                gameScene.viewController?.loadPuzzleScene(sceneName: "MicroscopePuzzleScene", completeDelegate: completePuzzle)
            default:
                gameScene.viewController?.loadPuzzleScene(sceneName: "TestTubePuzzleScene", completeDelegate: completePuzzle)
            }
        }
    }
    
    override func Damage(amount: Float)
    {
        super.Damage(amount: amount)
        setHealthUI()
    }
    
    func setHealthUI()
    {
        if let gameScene = scene as? GameScene
        {
            gameScene.viewController?.FacilityHealthBar?.progress = HealthPercentage()
        }
    }
    
    func increaseResearch()
    {
        if self.CurrentHealth > 0, let scene = self.scene as? GameScene
        {
            scene.ResearchPoint += PointGain
        }
    }
    
    func completePuzzle(completed : Bool)
    {
        if completed{
            Heal(amount: 0.05 * MaxHealth)
        }
    }
}
