//
//  FollowPlayerState.swift
//  MobileVirusDefender
//
//  Created by Tieran on 22/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class FollowPlayerState : StateProtocol
{
    var Player : PlayerEntity?
    
    var path : [Node]?
    var currentNode = 0
    var updatePathTime : Float = 0
    let pathfindingUpdatePeriod : Float = 0.25
    var currentTarget : CGPoint?
    
    func OnPush(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        //find player
        Player = scene.Player
    }
    
    func OnPop(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        Enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
    }
    
    func OnUpdate(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, deltaTime: Float, scene: GameScene)
    {
        if Player == nil
        {
            return
        }
        
        updatePathTime += deltaTime
        
        if(updatePathTime >= pathfindingUpdatePeriod)
        {
            FindPathToPlayer(enemy: Enemy, player: Player!, pathfinding: scene.pathfinding!)
            updatePathTime = 0
        }
        
        MoveAlongPath(enemy: Enemy, pathfinding: scene.pathfinding!)
    }
    
    func FindPathToPlayer(enemy : EnemyEntity, player: PlayerEntity, pathfinding : PathFinding)
    {
        if(path != nil && currentTarget == player.position)
        {
            return
        }
        
        let start = pathfinding.GetNode(worldPosition: enemy.position)
        let end = pathfinding.GetNode(worldPosition: player.position)
        
        if(start != nil && end != nil)
        {
            self.path = pathfinding.FindPath(start: start!, end: end!)
            currentTarget = player.position
            currentNode = 0
            //pathfinding.DrawPath(path: path!, scene: scene)
        }
        else{
            path = nil
        }
    }
    
    func MoveAlongPath(enemy : EnemyEntity, pathfinding : PathFinding)
    {
        if(path == nil || path!.isEmpty)
        {
            return
        }
        
        if(currentNode >= path!.count)
        {
            path = nil
            return
        }
        
        let nodeWorldPoint : CGPoint = pathfinding.ToWorldPosition(node: path![currentNode])
        let targetPosVector = CGVector(point: nodeWorldPoint);
        enemy.MoveTo(target: nodeWorldPoint)
        
        let distanceToTarget = CGVector(point: enemy.position).distanceTo(targetPosVector)
        if(distanceToTarget <= 10)
        {
            currentNode += 1
        }
    }
}
