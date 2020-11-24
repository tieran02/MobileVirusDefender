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
        MaxHealth = 1000
        Heal(amount: MaxHealth)
        
        Destructable = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsMask.Turret.rawValue
        
        //hide healthbar
        HealthBar.isHidden = true
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
}
