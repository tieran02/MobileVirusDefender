//
//  KnockbackState.swift
//  MobileVirusDefender
//
//  Created by Tieran on 28/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class KnockbackState : StateProtocol
{
    let target : BaseEntity
    
    let stunTime : Float = 0.5
    let KnockBackSpeed : CGFloat = 15
    var currentTime : Float = 0
    
    var pushBackTime : Float = 0.1
    
    init(target : BaseEntity)
    {
        self.target = target
    }
    
    func OnPush(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        //get directional vector from enemy to target
        let direction = CGVector(point:  Enemy.position - target.position).normalized()
        
        //enemy should be at the facility so set velocity to zero
        Enemy.SetVelocity(velocity: direction * KnockBackSpeed)
    }
    
    func OnPop(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        Enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
        
        //knockback clears what the AI was doing and goes back to move to facility
        
    }
    
    func OnUpdate(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, deltaTime: Float, scene: GameScene)
    {
        if(currentTime >= pushBackTime )
        {
            Enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
        }
        
        if(currentTime >= stunTime)
        {
            stateMachine.PopState(scene: scene)
            return
        }
        currentTime += deltaTime
    }
}
