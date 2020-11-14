//
//  PlayerEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class PlayerEntity : BaseEntity
{
    init()
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
