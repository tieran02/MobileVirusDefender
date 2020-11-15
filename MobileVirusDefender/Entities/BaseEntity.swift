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
    var Velocity : CGVector { get{ return self.physicsBody!.velocity } }
    
    let MaxHealth : Float
    
    private var _currentHealth : Float;
    var CurrentHealth : Float { get{ return _currentHealth } }
    
    var Speed : CGFloat = 1
    
    init(texture:SKTexture, maxHealth : Float, position: CGPoint = CGPoint(x: 0,y: 0))
    {
        MaxHealth = maxHealth
        _currentHealth = maxHealth;
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
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
        
        if _currentHealth <= 0
        {
            self.removeFromParent()
        }
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
        self.physicsBody!.velocity = velocity * CGFloat(TileMapSettings.TileSize);
    }
    
    func Update(deltaTime : Float, scene : GameScene)
    {
        
    }
    
    func collisionBegan(with: SKPhysicsBody)
    {
        
    }
}
