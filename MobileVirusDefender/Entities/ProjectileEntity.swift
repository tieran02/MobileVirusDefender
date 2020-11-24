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
    
    var currentAliveTime : Float = 0
    
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
    
    override func setup() {
        super.setup()
        //hide healthbar
        HealthBar.isHidden = true
    }
    
    func Fire(position : CGPoint, direction : CGVector, tileSize : CGFloat, scene : SKScene, Category : UInt32, Mask : UInt32)
    {
        physicsBody?.categoryBitMask = Category
        physicsBody?.collisionBitMask = Mask
        physicsBody?.contactTestBitMask = Mask
        
        //add to scene
        self.position = position;
        scene.addChild(self)
        
        self.MoveInDirection(direction: direction.normalized()	)
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        super.Update(deltaTime: deltaTime, scene: scene)
        
        //remove from parrent after lifetime
        if(self.parent != nil && currentAliveTime >= LifeTime)
        {
            self.removeFromParent()
            currentAliveTime = 0
        }
        currentAliveTime += deltaTime
    }
    
    override func collisionBegan(with: SKPhysicsBody)
    {
        let entity = with.node as? BaseEntity
        entity?.Damage(amount: Damage)
        self.removeFromParent()
        currentAliveTime = 0
    }
    
    override func Clone() -> BaseEntity {
        return ProjectileEntity(lifeTime: LifeTime)
    }
}
