//
//  EnemyEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 15/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class EnemyEntity : BaseEntity
{
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100, position: position)
        physicsBody?.categoryBitMask = PhysicsMask.Enemy.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.Envioment.rawValue
        
        Speed = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
