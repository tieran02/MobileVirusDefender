//
//  AttackFaciltyState.swift
//  MobileVirusDefender
//
//  Created by Tieran on 23/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class AttackEntityState : StateProtocol
{
    let target : BaseEntity

    var attackTimer : Float = 0
    let AttackSpeed : Float = 2
    
    init(target : BaseEntity)
    {
        self.target = target
    }
    
    func OnPush(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        //enemy should be at the facility so set velocity to zero
        Enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
    }
    
    func OnPop(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        
    }
    
    func OnUpdate(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, deltaTime: Float, scene: GameScene)
    {
        let distanceToTarget : CGFloat = CGVector(point: Enemy.position).distanceTo(CGVector(point:target.position))
        
        if(distanceToTarget > Enemy.AttackRange || target.CurrentHealth <= 0)
        {
            stateMachine.PopState(scene: scene)
            return
        }
        
        if(attackTimer >= AttackSpeed)
        {
            Enemy.Attack(entity: target)
            attackTimer = 0
        }
        attackTimer += deltaTime
    }
}
