//
//  SpawnerEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 22/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class SpawnerEntity : BaseEntity
{
    var spawnTimer : Float = 0.0
    let SpawnFrequency : Float
    let enemyPool : EntityPool<EnemyEntity>
    
    init(enemy : EnemyEntity, spawnFrequency : Float, position: CGPoint = CGPoint(x: 0,y: 0))
    {
        SpawnFrequency = spawnFrequency
        enemyPool = EntityPool<EnemyEntity>(entity: EnemyEntity(), Amount: 10)
        super.init(texture: SKTexture(imageNamed: "Turret0"), maxHealth: 200, position: position)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.SpawnFrequency = aDecoder.decodeObject(forKey: "SpawnFrequency") as? Float ?? 5
        self.enemyPool = aDecoder.decodeObject(forKey: "enemyPool") as? EntityPool<EnemyEntity> ?? EntityPool<EnemyEntity>(entity: EnemyEntity(), Amount: 10)
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup()
    {
        super.setup()
        
        Destructable = false
        physicsBody?.isDynamic = false
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        //update all spawned enemies
        enemyPool.Update(deltaTime: deltaTime, scene: scene)
        
        if(spawnTimer > SpawnFrequency)
        {
            if let enemy = enemyPool.Retrieve()
            {
                enemy.position = self.position
                enemy.Heal(amount: enemy.MaxHealth)
                scene.addChild(enemy)
                spawnTimer = 0
            }
        }
        
        spawnTimer += deltaTime
    
    }
}
