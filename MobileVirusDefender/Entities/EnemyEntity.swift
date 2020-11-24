//
//  EnemyEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 15/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class EnemyEntity : BaseEntity
{
    var path : [Node]?
    var currentNode = 0
    var updatePathTime : Float = 0
    let pathfindingUpdatePeriod : Float = 0.25
    var currentTarget : CGPoint?
    
    var StateMachine : FiniteStateMachine?
    
    let AttackDamage : Float = 5
    let AttackRange : CGFloat = CGFloat(TileMapSettings.TileSize)
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100, position: position)
        physicsBody?.categoryBitMask = PhysicsMask.Enemy.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Turret, PhysicsMask.Walls]).rawValue
        self.physicsBody?.linearDamping = 5
        Speed = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup()
    {
        super.setup()
        StateMachine = FiniteStateMachine(enemy: self)
        
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        super.Update(deltaTime: deltaTime, scene: scene)
        
        if(StateMachine?.currentState == nil)
        {
            StateMachine?.PushState(state: MoveToFacility(), scene: scene)
        }
        
        StateMachine?.Update(deltaTime: deltaTime, scene: scene)
    }
    
    func Attack(entity : BaseEntity)
    {
        entity.Damage(amount: AttackDamage)
    }

    override func Clone() -> BaseEntity {
        EnemyEntity(position: position)
    }
    
    override func Destroy()
    {
        super.Destroy()
        StateMachine?.Clear()
    }
    
}
