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
    
    let projectileSpawnPoint = CGPoint(x: 128, y: 0)
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "Idle - Rifle_000"), maxHealth: 100, position: position)
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
        size = CGSize(width: texture!.size().width * 0.4, height: texture!.size().height * 0.4)
        
        super.setup()
        physicsBody?.categoryBitMask = PhysicsMask.Player.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.PlayerMask.rawValue
        physicsBody?.contactTestBitMask = PhysicsMask.PlayerMask.rawValue
        
        super.AnimationStateDictionary[AnimationState.Idle] = SKAction(named: "PlayerIdle")
        super.AnimationStateDictionary[AnimationState.Running] = SKAction(named: "PlayerRun")
    }
    	
    func Fire(direction : CGVector, scene : GameScene)
    {
        if direction.lengthSquared() < 0.01
        {
            return
        }
        
        var spawnPoint = projectileSpawnPoint;
        if xScale < 0
        {
            spawnPoint = CGPoint(x: -spawnPoint.x, y: spawnPoint.y)
        }
        
        /*if let particles = SKEmitterNode(fileNamed: "MuzzleFlashParticle.sks") {
            particles.position = projectileSpawnPoint
            addChild(particles)
            
            let removeAfter = SKAction.sequence([SKAction.wait(forDuration: 1),SKAction.run {
                particles.removeFromParent()
            }])
            
            run(removeAfter)
        }*/
        
        //play sound
        let soundAction = SKAction.playSoundFileNamed("sci-fi_weapon_pistol_shot_01.wav", waitForCompletion: false)
        run(SKAction.sequence([SKAction.changeVolume(to: GlobalSoundManager.EffectVolume, duration: 0),
                                        soundAction]))
        
        let Projectile = scene.ProjectilePool.Retrieve()
        let category = PhysicsMask.PlayerProjectile.rawValue
        let mask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy, PhysicsMask.Turret, PhysicsMask.Walls]).rawValue
        Projectile?.Fire(position: self.position + spawnPoint,direction: direction,tileSize: 256,scene: scene,Category: category,Mask: mask)
        print("Firing")
    }
    
    override func Update(deltaTime: Float, scene : GameScene)
    {
        let leftDirection = scene.viewController?.LeftJoystick.Direction
        let rightDirection = scene.viewController?.RightJoystick.Direction
        if(leftDirection!.dx >= 0)
        {
            xScale = 1
        }
        else
        {
            xScale = -1
        }
        
        if(rightDirection!.dx > 0)
        {
            xScale = 1
        }
        else if(rightDirection!.dx < 0)
        {
            xScale = -1
        }
        
        super.shouldReverseAnimation = false
        if(leftDirection!.dx > 0 && rightDirection!.dx < 0 || leftDirection!.dx < 0 && rightDirection!.dx > 0 )
        {
            super.shouldReverseAnimation = true
        }
        
        
        super.Update(deltaTime: deltaTime, scene: scene)
        
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
                if enemy.StateMachine?.Peek() as? KnockbackState != nil
                {
                    //already knockedback/stunned
                    continue
                }
                enemy.StateMachine?.PushState(state: KnockbackState(target: self), scene: scene)
            }
        }
    }
    
    //todo add to util as it is used alot
    func getClosestEnemy(scene : GameScene) -> EnemyEntity?
    {
        let enemies = scene.children.compactMap{ $0 as? EnemyEntity}
        let playerPos = scene.Player.position
        
        var closestEnemy : EnemyEntity?
        var closestDistance : CGFloat?
        for enemy in enemies
        {
            if enemy.isHidden
            {
                continue
            }
            
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
      
    override func Destroy()
    {
        if let gamescene = scene as? GameScene
        {
            gamescene.viewController?.Gameover(score: gamescene.ResearchPoint)
        }
        super.Destroy()
    }
}
