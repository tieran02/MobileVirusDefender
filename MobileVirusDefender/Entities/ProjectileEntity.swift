//
//  ProjectileEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
class ProjectileEntity : BaseEntity
{
    let _lifeTime : Float
    
    init(lifeTime : Float)
    {
        _lifeTime = lifeTime;
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100)
        Speed = 10
        physicsBody?.categoryBitMask = PlayerProjectile;
        physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        _lifeTime = aDecoder.decodeObject(forKey: "_lifeTime") as! Float
        super.init(coder: aDecoder)
    }
    
    func Fire(position : CGPoint, direction : CGVector, tileSize : CGFloat, scene : SKScene)
    {
        
        //add to scene
        self.position = position;
        scene.addChild(self)
        self.MoveInDirection(direction: direction.normalized(), tileSize: tileSize)
        
        //remove from parrent after lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(_lifeTime))
        {
            self.removeFromParent()
        }
    }
    
    func Ready() -> Bool
    {
        return (self.parent == nil)
    }
    
}
