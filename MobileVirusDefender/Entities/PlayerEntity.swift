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
        physicsBody?.categoryBitMask = PhysicsMask.Player.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.Envioment.rawValue
        physicsBody?.contactTestBitMask = PhysicsMask.Envioment.rawValue
        
        Speed = 5
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    	
    func Fire(direction : CGVector, scene : GameScene)
    {
        if direction.lengthSquared() < 0.01
        {
            return
        }
        
        let Projectile = scene.ProjectilePool.Retrieve()
        Projectile?.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene)
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
        
        //get direction from player to enemy
        let direction = (CGVector(point: scene.Enemy.position) - CGVector(point: self.position)).normalized() * (20 * CGFloat(TileMapSettings.TileSize))
        
        
        scene.Enemy.ExternalForces = direction
    }
    
    override func Clone() -> BaseEntity {
        return PlayerEntity(position: position)
    }
}
