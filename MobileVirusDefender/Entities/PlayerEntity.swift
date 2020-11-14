//
//  PlayerEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//
        
import SpriteKit

class PlayerEntity : BaseEntity
{
    let projectilePool : [ProjectileEntity]
    var lastFire : Float = 0.0
    
    init()
    {
        self.projectilePool =  (0 ..< 50).map{_ in ProjectileEntity(lifeTime: 5)}
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100)
        physicsBody?.categoryBitMask = PlayerMask;
        physicsBody?.collisionBitMask = 0
        
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
        
        MoveInDirection(direction: leftDirection!, tileSize: 256)
        
        if(lastFire > 0.25){
            Fire(direction: rightDirection!, scene: scene)
            lastFire = 0
        }
        
        lastFire += deltaTime
    }
}
