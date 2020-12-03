//
//  EntityPool.swift
//  MobileVirusDefender
//
//  Created by Tieran on 16/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class EntityPool<EntityType> where EntityType : BaseEntity
{
    var pool = [EntityType]()
    
    //Have a copy of the phyisics bodies, this is so we can remove the body and only add it when we retrieve the item
    //This stops the objects colliding when hidden
    var physicalBodies = [SKPhysicsBody?]()
    
    init(entity : EntityType, Amount : Int)
    {
        for _ in 0 ..< Amount
        {
            let entity = entity.Clone(entityPool: true) as! EntityType
            entity.isHidden = true
            
            if entity.physicsBody != nil
            {
                let copy = entity.physicsBody!.copy() as! SKPhysicsBody
                physicalBodies.append(copy)
                entity.physicsBody = nil
            }
            else
            {
                physicalBodies.append(nil)
            }
            
            self.pool.append(entity)
        }
    }
    
    func addEntitiesToScene(scene : GameScene)
    {
        for entity in pool
        {
            if(entity.parent == nil){
                scene.addChild(entity)
            }
        }
    }
    
    func Update(deltaTime : Float, scene : GameScene)
    {
        for entity in pool
        {
            if(entity.isHidden != true)
            {
                entity.Update(deltaTime: deltaTime, scene: scene)
            }
        }
    }
    
    func Retrieve() -> EntityType?
    {
        for i in 0 ..< pool.count
        {
            if pool[i].isHidden
            {
                //add SKPhysicsBody back to the object
                pool[i].physicsBody = physicalBodies[i]
                return pool[i]
            }
        }
        return nil
    }
    
    func VisibleCount() -> Int
    {
        return pool.filter{ $0.isHidden == false}.count
    }
}
