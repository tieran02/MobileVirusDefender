//
//  EntityPool.swift
//  MobileVirusDefender
//
//  Created by Tieran on 16/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import Foundation

class EntityPool<EntityType> where EntityType : BaseEntity
{
    let pool : [EntityType]
    
    init(entity : EntityType, Amount : Int)
    {
        pool =  (0 ..< Amount).map{_ in entity.Clone(entityPool: true) as! EntityType}
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
        return pool.first(where: {$0.parent == nil})
    }
}
