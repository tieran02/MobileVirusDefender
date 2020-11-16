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
    let LifeTime : Float
    let Damage : Float
    
    init(lifeTime : Float)
    {
        LifeTime = lifeTime
        Damage = 25
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100)
        Speed = 10
        physicsBody?.categoryBitMask = PhysicsMask.PlayerProjectile.rawValue
        physicsBody?.collisionBitMask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy]).rawValue
        physicsBody?.contactTestBitMask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy]).rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        LifeTime = aDecoder.decodeObject(forKey: "LifeTime") as! Float
        Damage = aDecoder.decodeObject(forKey: "Damage") as! Float
        super.init(coder: aDecoder)
    }
    
    func Fire(position : CGPoint, direction : CGVector, tileSize : CGFloat, scene : SKScene)
    {
        
        //add to scene
        self.position = position;
        scene.addChild(self)
        
        self.MoveInDirection(direction: direction.normalized()	)
        
        //remove from parrent after lifetime
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(LifeTime))
        {
            self.removeFromParent()
        }
    }
    
    func Ready() -> Bool
    {
        return (self.parent == nil)
    }
    
    override func collisionBegan(with: SKPhysicsBody)
    {
        let entity = with.node as? BaseEntity
        entity?.Damage(amount: Damage)
        self.removeFromParent()
    }
    
}
