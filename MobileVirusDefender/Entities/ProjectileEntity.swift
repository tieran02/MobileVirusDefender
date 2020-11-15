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
        physicsBody?.categoryBitMask = PhysicsMask.PlayerProjectile.rawValue
        physicsBody?.collisionBitMask = PhysicsMask.Envioment.rawValue
        physicsBody?.contactTestBitMask = PhysicsMask.Envioment.rawValue
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
        self.MoveInDirection(direction: direction.normalized()	)
        
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
    
    override func collisionBegan(with: SKPhysicsBody) {
        self.removeFromParent()
    }
    
}
