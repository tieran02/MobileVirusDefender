//
//  BaseEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
import CoreMotion

protocol Cloneable {
    func Clone() -> BaseEntity
}

class BaseEntity : SKSpriteNode, Cloneable
{
    var _velocity : CGVector = CGVector(dx: 0, dy: 0)
    var Velocity : CGVector { get{ return _velocity } }
    
    var MaxHealth : Float
    
    private var _currentHealth : Float;
    var CurrentHealth : Float { get{ return _currentHealth } }
    
    var Speed : CGFloat = 1
    var ExternalForces : CGVector = CGVector(dx: 0, dy: 0)
    var Destructable : Bool = true
    
    init(texture:SKTexture, maxHealth : Float, position: CGPoint = CGPoint(x: 0,y: 0))
    {
        MaxHealth = maxHealth
        _currentHealth = maxHealth;
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
        
        setup()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        MaxHealth = 100
        _currentHealth = MaxHealth
        super.init(texture: texture,color: color,size: size)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.MaxHealth = aDecoder.decodeObject(forKey: "MaxHealth") as? Float ?? 100
        self._currentHealth = aDecoder.decodeObject(forKey: "CurrentHealth") as? Float ?? 100
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup()
    {
        if(self.physicsBody == nil && texture != nil)
        {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: texture!.size())
        }
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func Damage(amount: Float)
    {
        if(!Destructable)
        {
            return
        }
        
        _currentHealth = max(CurrentHealth - amount,0)
        
        if _currentHealth <= 0
        {
            Destroy()
        }
    }
    
    func Destroy()
    {
        self.removeFromParent()
    }
    
    func Heal(amount: Float)
    {
        _currentHealth = min(CurrentHealth + amount, MaxHealth)
    }
    
    func MoveInDirection(direction : CGVector)
    {
        SetVelocity(velocity: direction * Speed)
    }
    
    func SetVelocity(velocity: CGVector)
    {
        _velocity = (velocity * CGFloat(TileMapSettings.TileSize));
    }
    
    func MoveTo(target : CGPoint)
    {
        //Get direction to target
        let targetVector = CGVector(point: target)
        let selfVector = CGVector(point: self.position)
        let direction = (targetVector - selfVector).normalized()
        let distance = selfVector.distanceTo(targetVector)
        
        if(distance > 10){
            MoveInDirection(direction: direction)
        }
    }
    
    func Update(deltaTime : Float, scene : GameScene)
    {
        ExternalForces *= CGFloat(pow(0.002, deltaTime))
        physicsBody?.velocity = Velocity + ExternalForces
    }
    
    func collisionBegan(with: SKPhysicsBody)
    {
        
    }
    
    func Acceleration(acceleration : CMAcceleration, scene : GameScene)
    {
        
    }
    
    func Clone() -> BaseEntity
    {
        return BaseEntity(texture: texture!,maxHealth: MaxHealth,position: position)
    }
    
}
