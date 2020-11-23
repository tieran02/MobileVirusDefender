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
    let maxDistance : CGFloat = CGFloat(TileMapSettings.TileSize) * 5
    
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
        self.isUserInteractionEnabled = true
        Destructable = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsMask.Turret.rawValue
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        if(lastFire > 1){
            if let enemy = getClosestEnemy(scene: scene)
            {
                if let Projectile = scene.ProjectilePool.Retrieve()
                {
                    //temp get direction to enemy
                    let direction = (CGVector(point: enemy.position) - CGVector(point: position)).normalized()
                    
                    let category = PhysicsMask.TurretProjectile.rawValue
                    let mask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy]).rawValue
                    Projectile.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene, Category: category,Mask: mask)
                    lastFire = 0
                }
            }
        }
        
        lastFire += deltaTime
    
    }
    
    func getClosestEnemy(scene : GameScene) -> EnemyEntity?
    {
        let enemies = scene.children.compactMap{ $0 as? EnemyEntity}
        var closestEnemy : EnemyEntity?
        var closestDistance : CGFloat?
        for enemy in enemies
        {
            let dist = CGVector(point: position).distanceTo(CGVector(point: enemy.position))
            
            if(dist > maxDistance)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        print("touched")
        if let gameScene = scene as? GameScene
        {
            //setup puzzle delegate
            gameScene.viewController?.loadPuzzleScene(sceneName: "WirePuzzleScene", completeDelegate: completePuzzle)
        }
    }
    
    func completePuzzle(completed : Bool)
    {
        
    }
}
