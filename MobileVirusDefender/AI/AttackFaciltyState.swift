//
//  AttackFaciltyState.swift
//  MobileVirusDefender
//
//  Created by Tieran on 23/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class AttackFacilityState : StateProtocol
{
    var facility : ResearchEntity?
    var Player : PlayerEntity?
    
    var attackTimer : Float = 0
    let AttackSpeed : Float = 2
    
    func OnPush(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        //find facility
        facility = scene.ResearchFacility
        Player = scene.Player
        
        //enemy should be at the facility so set velocity to zero
        Enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
    }
    
    func OnPop(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        
    }
    
    func OnUpdate(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, deltaTime: Float, scene: GameScene)
    {
        if(facility == nil)
        {
            return
        }
        
        if(attackTimer >= AttackSpeed)
        {
            Enemy.Attack(entity: facility!)
            attackTimer = 0
        }
        attackTimer += deltaTime
    }
}
