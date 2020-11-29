//
//  PlaceableTurret.swift
//  MobileVirusDefender
//
//  Created by Tieran on 28/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class PlaceableTurret : BaseEntity
{
    var fireTimer : Float = 0.0
    let maxDistance : CGFloat = CGFloat(TileMapSettings.TileSize) * 2.5
    
    let MaxShots : Int = 25
    var currentShots : Int = 0
    
    let TimeLimit : Float = 120
    var currentTime : Float = 0
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "Turret0"), maxHealth: 100, position: position)
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
        physicsBody = nil
        zPosition = -1
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
                
        if currentShots < MaxShots && fireTimer > 1
        {
            if let enemy = getClosestEnemy(scene: scene)
            {
                if let Projectile = scene.ProjectilePool.Retrieve()
                {
                    //temp get direction to enemy
                    let direction = (CGVector(point: enemy.position) - CGVector(point: position)).normalized()
                    
                    let category = PhysicsMask.TurretProjectile.rawValue
                    let mask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy]).rawValue
                    Projectile.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene, Category: category,Mask: mask)
                    fireTimer = 0
                    currentShots+=1
                }
            }
        }
        else if currentShots >= MaxShots || currentTime >= TimeLimit
        {
            Destroy()
            return
        }
        
        fireTimer += deltaTime
        currentTime += deltaTime
    
    }
    
    func Reset()
    {
        currentShots = 0
        currentTime = 0
        Heal(amount: MaxHealth)
    }
    
    func getClosestEnemy(scene : GameScene) -> EnemyEntity?
    {
        let enemies = scene.children.compactMap{ $0 as? EnemyEntity}
        var closestEnemy : EnemyEntity?
        var closestDistance : CGFloat?
        for enemy in enemies
        {
            let dist = CGVector(point: position).distanceTo(CGVector(point: enemy.position))
            
            if(enemy.CurrentHealth <= 0 || dist > maxDistance)
            {
                continue
            }
            else if closestEnemy == nil
            {
                closestEnemy = enemy
                closestDistance = dist
                continue
            }
            else if dist < closestDistance!
            {
                closestEnemy = enemy
                closestDistance = dist
            }
        }
        return closestEnemy
    }
    
    override func Clone() -> BaseEntity {
        return PlaceableTurret()
    }
}
