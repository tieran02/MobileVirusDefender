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
    let projectilePool : [ProjectileEntity]
    var lastFire : Float = 0.0
    let pushbackThreshold : Double = 0.5
    var pushbackTimer : Float = 0.0
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        self.projectilePool =  (0 ..< 50).map{_ in ProjectileEntity(lifeTime: 5)}
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100, position: position)
        physicsBody?.categoryBitMask = PhysicsMask.Player.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.Envioment.rawValue
        
        Speed = 5
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        projectilePool = aDecoder.decodeObject(forKey: "projectilePool") as! [ProjectileEntity]
        super.init(coder: aDecoder)
    }
    	
    func Fire(direction : CGVector, scene : SKScene)
    {
        if direction.lengthSquared() < 0.01
        {
            return
        }
        
        let Projectile = projectilePool.first(where: {$0.Ready()})
        Projectile?.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene)
        print("Firing")
    }
    
    override func Update(deltaTime: Float, scene : GameScene)
    {
        let leftDirection = scene.viewController?.LeftJoystick.Direction
        let rightDirection = scene.viewController?.RightJoystick.Direction

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
        let direction = (CGVector(point: scene.Enemy.position) - CGVector(point: self.position)).normalized() * (200 * CGFloat(TileMapSettings.TileSize))
        
        
        scene.Enemy.physicsBody?.applyForce(direction)
    }
}
