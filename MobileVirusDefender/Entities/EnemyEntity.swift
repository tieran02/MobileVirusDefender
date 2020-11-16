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
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100, position: position)
        physicsBody?.categoryBitMask = PhysicsMask.Enemy.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.Envioment.rawValue
        self.physicsBody?.linearDamping = 5
        Speed = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        updatePathTime += deltaTime
        
        if(updatePathTime >= pathfindingUpdatePeriod)
        {
            FindPathToTarget(target: scene.Player.position, pathfinding: scene.pathfinding!)
            updatePathTime = 0
        }
        
        //MoveAlongPath(pathfinding: scene.pathfinding!)
    }
    
    func FindPathToTarget(target : CGPoint, pathfinding : PathFinding)
    {
        if(path != nil && currentTarget == target)
        {
            return
        }
        
        let start = pathfinding.GetNode(worldPosition: self.position)
        let end = pathfinding.GetNode(worldPosition: target)
        
        if(start != nil && end != nil)
        {
            self.path = pathfinding.FindPath(start: start!, end: end!)
            currentTarget = target
            currentNode = 0
            //pathfinding.DrawPath(path: path!, scene: scene)
        }
        else{
            path = nil
        }
    }
    
    func MoveAlongPath(pathfinding : PathFinding)
    {
        if(path == nil)
        {
            return
        }
        
        if(currentNode >= path?.count ?? 0)
        {
            SetVelocity(velocity: CGVector(dx: 0, dy: 0))
            return
        }
        
        let nodeWorldPoint : CGPoint = pathfinding.ToWorldPosition(node: path![currentNode])
        let targetPosVector = CGVector(point: nodeWorldPoint);
        MoveTo(target: nodeWorldPoint)
        
        let distanceToTarget = CGVector(point: self.position).distanceTo(targetPosVector)
        if(distanceToTarget <= 10)
        {
            currentNode += 1
        }
    }
    
    
}
