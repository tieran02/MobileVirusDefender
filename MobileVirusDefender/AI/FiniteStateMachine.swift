//
//  FiniteStateMachine.swift
//  MobileVirusDefender
//
//  Created by Tieran on 22/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

protocol StateProtocol
{
    func OnPush(Enemy : EnemyEntity, stateMachine : FiniteStateMachine, scene : GameScene)
    func OnPop(Enemy : EnemyEntity, stateMachine : FiniteStateMachine, scene : GameScene)
    func OnUpdate(Enemy : EnemyEntity, stateMachine : FiniteStateMachine, deltaTime : Float, scene : GameScene)
}

class FiniteStateMachine
{
    let Enemy : EnemyEntity
    var stateStack : [StateProtocol]?
    var currentState : StateProtocol?
    
    init(enemy : EnemyEntity)
    {
        Enemy = enemy
    }
    
    func PushState(state : StateProtocol, scene : GameScene)
    {
        stateStack?.append(state)
        currentState = state
        currentState?.OnPush(Enemy: Enemy, stateMachine: self, scene: scene)
    }
    
    func PopState(scene : GameScene) -> StateProtocol?
    {
        let state = stateStack?.removeFirst()
        state?.OnPop(Enemy: Enemy, stateMachine: self, scene: scene)
        currentState = Peek()
        return state
    }
    
    func Peek() -> StateProtocol?
    {
        return stateStack?.first
    }
    
    func Clear()
    {
        currentState = nil
        stateStack?.removeAll()
    }
    
    func Update(deltaTime : Float, scene : GameScene)
    {
        currentState?.OnUpdate(Enemy: Enemy, stateMachine: self, deltaTime: deltaTime, scene: scene)
    }
}
