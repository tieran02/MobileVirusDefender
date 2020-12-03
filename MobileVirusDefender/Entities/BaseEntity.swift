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
    func Clone(entityPool : Bool) -> BaseEntity
}

class BaseEntity : SKSpriteNode, Cloneable
{
    
    enum AnimationState
    {
        case Idle
        case Running
        case Attacking
        case Dying
        case Stun
    }
    
    var _velocity : CGVector = CGVector(dx: 0, dy: 0)
    var Velocity : CGVector { get{ return _velocity } }
    
    var MaxHealth : Float
    
    private var _currentHealth : Float;
    var CurrentHealth : Float { get{ return _currentHealth } }
    
    var Speed : CGFloat = 1
    var ExternalForces : CGVector = CGVector(dx: 0, dy: 0)
    var Destructable : Bool = true
    
    let HealthBar : ProgressBarSprite
    
    var AnimationStateDictionary = [AnimationState : SKAction]()
    var currentAnimationState : AnimationState = AnimationState.Idle
    var shouldReverseAnimation : Bool = false
    private var reverseAnimation : Bool = false
    var _isEntityPool : Bool = false
    
    init(texture:SKTexture, maxHealth : Float, position: CGPoint = CGPoint(x: 0,y: 0))
    {
        MaxHealth = maxHealth
        _currentHealth = maxHealth;
        HealthBar = ProgressBarSprite(color: SKColor.red, size: CGSize(width: 128, height: 10))
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.position = position
        
        addChild(HealthBar)
        setup()
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        MaxHealth = 100
        _currentHealth = MaxHealth
        HealthBar = ProgressBarSprite(color: SKColor.red, size: CGSize(width: 128, height: 10))
        super.init(texture: texture,color: color,size: size)
        
        addChild(HealthBar)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.MaxHealth = aDecoder.decodeObject(forKey: "MaxHealth") as? Float ?? 100
        self._currentHealth = aDecoder.decodeObject(forKey: "CurrentHealth") as? Float ?? 100
        self.HealthBar = ProgressBarSprite(color: SKColor.red, size: CGSize(width: 128, height: 10))
        super.init(coder: aDecoder)
        
        addChild(HealthBar)
        setup()
    }
    
    func setup()
    {
        if(self.physicsBody == nil && texture != nil)
        {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: size)
        }
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        HealthBar.position = CGPoint(x: 0, y: (self.size.height / 2) + 10 )
        HealthBar.zPosition = 200
        HealthBar.Progress = 1
    }
    
    func Damage(amount: Float)
    {
        if(!Destructable)
        {
            return
        }
        
        _currentHealth = max(CurrentHealth - amount,0)
        HealthBar.Progress = CGFloat(HealthPercentage())
        
        if _currentHealth <= 0 && currentAnimationState != .Dying
        {
            Destroy()
        }
    }
    
    func Destroy()
    {
        if let action = AnimationStateDictionary[.Dying]
        {
            currentAnimationState = .Dying
            run(SKAction.sequence([action, SKAction.run {
                self.removeOrHide()
            }]))
        }
        else
        {
            removeOrHide()
        }
    }
    
    func removeOrHide()
    {
        if _isEntityPool{
            self.isHidden = true
        }
        else{
            self.removeFromParent()
        }
    }
    
    func Heal(amount: Float)
    {
        _currentHealth = min(CurrentHealth + amount, MaxHealth)
        HealthBar.Progress = CGFloat(HealthPercentage())
    }
    
    func HealthPercentage() -> Float
    {
        return _currentHealth / MaxHealth
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
    
    func Rotate(radians : CGFloat)
    {
        self.zRotation = radians
        
        let dx = size.width * 0.5
        let dy = size.height  * 0.5
        let radius :CGFloat = sqrt(dx*dx + dy*dy)
        let x = cos(-self.zRotation + 1.5708)*radius
        let y = sin(-self.zRotation + 1.5708)*radius
        
        
        self.HealthBar.position = CGPoint(x: x, y: y)
        self.HealthBar.zRotation = -radians
        
    }
    
    func Update(deltaTime : Float, scene : GameScene)
    {
        if(currentAnimationState == AnimationState.Dying)
        {
            physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            return
        }
        
        ExternalForces *= CGFloat(pow(0.002, deltaTime))
        physicsBody?.velocity = Velocity + ExternalForces
        
        
        //if no action is running then idle,
        if !hasActions()
        {
            runAnimationState(state: AnimationState.Idle)
        }
        
        //set animation
        if Velocity.lengthSquared() != 0 && (currentAnimationState == AnimationState.Idle || shouldReverseAnimation != reverseAnimation)
        {
            runAnimationState(state: AnimationState.Running)
        }
        else if Velocity.lengthSquared() == 0 && (currentAnimationState == AnimationState.Running || shouldReverseAnimation != reverseAnimation)
        {
            runAnimationState(state: AnimationState.Idle)
        }
    }
    
    func runAnimationState(state : AnimationState)
    {
        if let action = AnimationStateDictionary[state]
        {
            self.removeAction(forKey: "animation")
            if(shouldReverseAnimation)
            {
                self.run(action.reversed(), withKey: "animation")
            }
            else{
                self.run(action, withKey: "animation")
            }
            currentAnimationState = state
            reverseAnimation = shouldReverseAnimation
        }
    }
    
    func collisionBegan(with: SKPhysicsBody)
    {
        
    }
    
    func Acceleration(acceleration : CMAcceleration, scene : GameScene)
    {
        
    }
    
    func Clone(entityPool : Bool) -> BaseEntity
    {
        let entity = BaseEntity(texture: texture!,maxHealth: MaxHealth,position: position)
        entity._isEntityPool = entityPool
        return entity
    }
    
}
