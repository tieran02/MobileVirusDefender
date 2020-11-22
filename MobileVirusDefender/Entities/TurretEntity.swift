//
//  TurretEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 22/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class TurretEntity : BaseEntity
{
    var lastFire : Float = 0.0
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "Turret0"), maxHealth: 200, position: position)
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
        
        Destructable = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsMask.Turret.rawValue
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        if(lastFire > 0.25){
            let Projectile = scene.ProjectilePool.Retrieve()
            
            //temp get direction to enemy
            let direction = (CGVector(point: scene.Enemy.position) - CGVector(point: position)).normalized()
            
            let category = PhysicsMask.TurretProjectile.rawValue
            let mask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy]).rawValue
            Projectile?.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene, Category: category,Mask: mask)
            lastFire = 0
        }
        
        lastFire += deltaTime
    
    }
}
