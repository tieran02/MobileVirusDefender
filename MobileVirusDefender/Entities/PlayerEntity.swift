//
//  PlayerEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//
        
import SpriteKit
import CoreMotion

class PlayerEntity : BaseEntity
{
    var lastFire : Float = 0.0
    let pushbackThreshold : Double = 0.5
    var pushbackTimer : Float = 0.0
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "Player"), maxHealth: 100, position: position)
        Speed = 5
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.Speed = aDecoder.decodeObject(forKey: "Speed") as? CGFloat ?? 5
        setup()
    }
    
    override func setup()
    {
        super.setup()
        physicsBody?.categoryBitMask = PhysicsMask.Player.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.PlayerMask.rawValue
        physicsBody?.contactTestBitMask = PhysicsMask.PlayerMask.rawValue
    }
    	
    func Fire(direction : CGVector, scene : GameScene)
    {
        if direction.lengthSquared() < 0.01
        {
            return
        }
        
        let Projectile = scene.ProjectilePool.Retrieve()
        let category = PhysicsMask.PlayerProjectile.rawValue
        let mask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy, PhysicsMask.Turret]).rawValue
        Projectile?.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene,Category: category,Mask: mask)
        print("Firing")
    }
    
    override func Update(deltaTime: Float, scene : GameScene)
    {
        super.Update(deltaTime: deltaTime, scene: scene)
        
        let leftDirection = scene.viewController?.LeftJoystick.Direction
        let rightDirection = scene.viewController?.RightJoystick.Direction
        
        let angleOffset : CGFloat = 0.0872665 //offset in radians to make the gun align with bullets
        if(leftDirection!.lengthSquared() > 0)
        {
            zRotation = leftDirection!.angle() + angleOffset
        }
        if(rightDirection!.lengthSquared() > 0)
        {
            zRotation = rightDirection!.angle() + angleOffset
        }

        MoveInDirection(direction: leftDirection!)
        
        if(lastFire > 0.25){
            Fire(direction: rightDirection!, scene: scene)
            lastFire = 0
        }
        
        pushbackTimer += deltaTime
        lastFire += deltaTime
    }
    
    override func Acceleration(acceleration: CMAcceleration, scene : GameScene)
    {
        if(abs(acceleration.y) >= self.pushbackThreshold && pushbackTimer >= 1.0)
        {
            PushbackEnemies(radius: Float(1 * TileMapSettings.TileSize), scene: scene)
            pushbackTimer = 0.0
        }
    }

    
    func PushbackEnemies(radius : Float, scene : GameScene)
    {
        print("Push back infected")
        
        let enemies = scene.children.compactMap{ $0 as? EnemyEntity}
        for enemy in enemies
        {
            let dist = CGVector(point: position).distanceTo(CGVector(point: enemy.position))
            
            if dist <= CGFloat(TileMapSettings.TileSize) * 2.5
            {
                //get direction from player to enemy
                let direction = (CGVector(point: enemy.position) - CGVector(point: self.position)).normalized() * (20 * CGFloat(TileMapSettings.TileSize))
                enemy.ExternalForces = direction
            }
        }
    }
    
    func getClosestEnemy(scene : GameScene) -> EnemyEntity?
    {
        let enemies = scene.children.compactMap{ $0 as? EnemyEntity}
        let playerPos = scene.Player.position
        
        var closestEnemy : EnemyEntity?
        var closestDistance : CGFloat?
        for enemy in enemies
        {
            let dist = CGVector(point: playerPos).distanceTo(CGVector(point: enemy.position))
            
            if closestEnemy == nil
            {
                closestEnemy = enemy
                closestDistance = dist
                continue
            }
            

            if dist < closestDistance!
            {
                closestEnemy = enemy
                closestDistance = dist
            }
        }
        return closestEnemy
    }
    
    override func Clone() -> BaseEntity {
        return PlayerEntity(position: position)
    }
}
