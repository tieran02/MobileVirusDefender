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
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 100, position: position)
        physicsBody?.categoryBitMask = PhysicsMask.Enemy.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask.Envioment.rawValue
        
        Speed = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        if(self.path == nil)
        {
            let start = scene.pathfinding?.GetNode(position: self.position)
            let end = scene.pathfinding?.GetNode(position: scene.Player.position)
            
            if(start != nil && end != nil)
            {
                self.path = scene.pathfinding?.FindPath(start: start!, end: end!)
                
                scene.pathfinding?.DrawPath(path: path!, scene: scene)
            }
        }
        else if(currentNode < path!.count)
        {
            let nodeWorldPoint : CGPoint = scene.pathfinding!.ToWorldPosition(node: path![currentNode])
            let targetPosVector = CGVector(point: nodeWorldPoint);
            MoveTo(target: nodeWorldPoint)
            
            let distanceToTarget = CGVector(point: self.position).distanceTo(targetPosVector)
            if(distanceToTarget <= 10)
            {
                currentNode += 1
            }
        }
        else{
            SetVelocity(velocity: CGVector(dx: 0, dy: 0))
        }
    }
}
