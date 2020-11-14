//
//  BaseEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class BaseEntity : SKSpriteNode
{
    let PlayerMask : UInt32 =  0x1 << 1
    let PlayerProjectile : UInt32 = 0x1 << 2
    
    var Velocity : CGVector { get{ return self.physicsBody!.velocity } }
    
    let MaxHealth : Float
    
    private var _currentHealth : Float;
    var CurrentHealth : Float { get{ return _currentHealth } }
    
    var Speed : CGFloat = 1
    
    init(texture:SKTexture, maxHealth : Float)
    {
        MaxHealth = maxHealth
        _currentHealth = maxHealth;
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height));
        self.physicsBody?.affectedByGravity = false
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        MaxHealth = aDecoder.decodeObject(forKey: "MaxHealth") as! Float
        _currentHealth = aDecoder.decodeObject(forKey: "CurrentHealth") as! Float
        super.init(coder: aDecoder)
    }
    
    func Damage(amount: Float)
    {
        _currentHealth = max(CurrentHealth - amount,0)
    }
    
    func Heal(amount: Float)
    {
        _currentHealth = min(CurrentHealth + amount, MaxHealth)
    }

    
    func MoveInDirection(direction : CGVector, tileSize : CGFloat)
    {
        SetVelocity(velocity: direction * Speed, tileSize: tileSize)
    }
    
    func SetVelocity(velocity: CGVector, tileSize : CGFloat)
    {
        self.physicsBody!.velocity = velocity * tileSize;
    }
    
    func Update(deltaTime : Float, scene : GameScene)
    {
        
    }
}
