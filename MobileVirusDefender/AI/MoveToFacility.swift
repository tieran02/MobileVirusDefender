//
//  MoveToFacility.swift
//  MobileVirusDefender
//
//  Created by Tieran on 23/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class MoveToFacility : StateProtocol
{
    var facility : ResearchEntity?
    var Player : PlayerEntity?
    
    var path : [Node]?
    var currentNode = 0
    var updatePathTime : Float = 0
    let pathfindingUpdatePeriod : Float = 2.5
    var currentTarget : CGPoint?
    
    func OnPush(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        //find facility
        facility = scene.ResearchFacility
        Player = scene.Player
        currentNode = 0
        currentTarget = nil
        updatePathTime = pathfindingUpdatePeriod
        //FindPathToFacility(enemy: Enemy, facility: facility!, pathfinding: scene.pathfinding!)
    }
    
    func OnPop(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, scene: GameScene)
    {
        Enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
    }
    
    func OnUpdate(Enemy: EnemyEntity, stateMachine: FiniteStateMachine, deltaTime: Float, scene: GameScene)
    {
        if facility == nil
        {
            return
        }
        
        //check distance to facility, if within range then change to attack state
        let distanceToFacility = CGVector(point: Enemy.position).distanceTo(CGVector(point: facility!.position))
        if distanceToFacility <= Enemy.AttackRange
        {
            //enemy is within 1 units of facility so attack facility
            stateMachine.PushState(state: AttackEntityState(target: facility!), scene: scene)
            return
        }
        
        //check if enemy is next to a gate is so attack it
        if let gate = AIHelpers.GetGateWithinDistance(scene: scene, enemyPosition: Enemy.position)
        {
            stateMachine.PushState(state: AttackEntityState(target: gate), scene: scene)
            return
        }
        
        //check if the player is within range
        if(Player != nil)
        {
            let distanceToPlayer = CGVector(point: Enemy.position).distanceTo(CGVector(point: Player!.position))
            if distanceToPlayer <= CGFloat(TileMapSettings.TileSize) * 5
            {
                //player is within 5 units, so follow the player
                stateMachine.PushState(state: FollowPlayerState(), scene: scene)
                return
            }
        }
        
        updatePathTime += deltaTime
        
        if(updatePathTime >= pathfindingUpdatePeriod)
        {
            FindPathToFacility(enemy: Enemy, facility: facility!, pathfinding: scene.pathfinding!, scene: scene)
            updatePathTime = 0
        }
        
        MoveAlongPath(enemy: Enemy, pathfinding: scene.pathfinding!)
    }
    
    func FindPathToFacility(enemy : EnemyEntity, facility: ResearchEntity, pathfinding : PathFinding, scene : GameScene)
    {
        if(path != nil && currentTarget == facility.position)
        {
            return
        }
        
        let start = pathfinding.GetNode(worldPosition: enemy.position)
        let end = pathfinding.GetNode(worldPosition: facility.position)
        
        if(start != nil && end != nil)
        {
            self.path = pathfinding.FindPath(start: start!, end: end!)
            currentTarget = facility.position
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
            enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
            return
        }
        
        if(currentNode >= path!.count)
        {
            path = nil
            enemy.SetVelocity(velocity: CGVector(dx: 0, dy: 0))
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
