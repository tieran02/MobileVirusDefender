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
    
    var ShotsTillTimeout : Int?
    var currentShots : Int = 0
    
    let arrow = ArrowSprite()
    let gun = SKSpriteNode(imageNamed: "towergun00")
    
    let turretAudio = SKAudioNode(fileNamed: "sci-fi_weapon_auto_turret_release_01.wav")
    
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
        
        //hide healthbar
        HealthBar.isHidden = true
        
        //add turrer gun
        gun.removeFromParent()
        gun.zPosition = 10
        gun.size = self.size
        addChild(gun)
        
        turretAudio.removeFromParent()
        turretAudio.isPositional = true
        turretAudio.autoplayLooped = false
        addChild(turretAudio)
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        
        if(ShotsTillTimeout == nil)
        {
            ShotsTillTimeout = Int.random(in: 25...50)
            currentShots = 0
            showDirectionalArrow(scene: scene, visible: false)
        }
        
        if(currentShots >= ShotsTillTimeout!)
        {
            showDirectionalArrow(scene: scene, visible: true)
            return
        }
        
        if(lastFire > 1){
            if let enemy = getClosestEnemy(scene: scene)
            {
                if let Projectile = scene.ProjectilePool.Retrieve()
                {
                    //temp get direction to enemy
                    let direction = (CGVector(point: enemy.position) - CGVector(point: position)).normalized()
                    
                    //turn turret to direction
                    gun.zRotation = direction.angle()
                    if let action = SKAction(named: "TowerFire")
                    {
                        gun.run(action)
                    }
                    
                    turretAudio.run(SKAction.sequence([SKAction.changeVolume(to: GlobalSoundManager.EffectVolume, duration: 0),
                                                       SKAction.play()]))
                    
                    let category = PhysicsMask.TurretProjectile.rawValue
                    let mask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Enemy]).rawValue
                    Projectile.Fire(position: self.position,direction: direction,tileSize: 256,scene: scene, Category: category,Mask: mask)
                    lastFire = 0
                    currentShots+=1
                    
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
            
            if(dist > maxDistance || enemy.CurrentHealth <= 0)
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
        if currentShots >= ShotsTillTimeout ?? 0, let gameScene = scene as? GameScene
        {
            if(position.distanceTo(gameScene.Player.position) >= CGFloat(TileMapSettings.TileSize * 2))
            {
                return
            }
            
            //setup puzzle delegate
            gameScene.viewController?.loadPuzzleScene(sceneName: "WirePuzzleScene", completeDelegate: completePuzzle)
        }
    }
    
    func showDirectionalArrow(scene : GameScene, visible : Bool)
    {
        if(arrow.parent == nil && visible)
        {
            scene.addChild(arrow)
        }
        
        if(visible)
        {
            arrow.clampToView(scene: scene, scenePoint: position, targetPoint: scene.Player.position)
        }
        else
        {
            arrow.removeFromParent()
        }

    }
    
    func completePuzzle(completed : Bool)
    {
        if completed{
            ShotsTillTimeout = nil
        }
    }
}
