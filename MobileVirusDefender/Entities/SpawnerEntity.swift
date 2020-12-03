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
    
    init(enemy : EnemyEntity, spawnFrequency : Float, position: CGPoint = CGPoint(x: 0,y: 0))
    {
        SpawnFrequency = spawnFrequency
        super.init(texture: SKTexture(imageNamed: "Turret0"), maxHealth: 200, position: position)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.SpawnFrequency = aDecoder.decodeObject(forKey: "SpawnFrequency") as? Float ?? 5
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup()
    {
        super.setup()
        
        Destructable = false
        physicsBody?.isDynamic = false
        
        //hide healthbar
        HealthBar.isHidden = true
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        if(spawnTimer > SpawnFrequency)
        {
            if let enemy = scene.EnemyPool.Retrieve()
            {
                enemy.position = CGPoint(x: floor(self.position.x), y: floor(self.position.y))
                enemy.Reset()
                enemy.isHidden = false
                enemy.StateMachine?.PushState(state: MoveToFacility(), scene: scene)
                spawnTimer = 0
            }
        }
        
        spawnTimer += deltaTime
    
    }
}
