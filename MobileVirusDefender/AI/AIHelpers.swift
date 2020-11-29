//
//  AIHelpers.swift
//  MobileVirusDefender
//
//  Created by Tieran on 29/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class AIHelpers
{
    static func GetGateWithinDistance(scene : GameScene, enemyPosition : CGPoint) -> GateEntity?
    {
        let gates = scene.children.compactMap{ $0 as? GateEntity}
        var closestGate : GateEntity?
        var closestDistance : CGFloat?
        for gate in gates
        {
            if(gate.Open)
            {
                continue
            }
            
            let dist = CGVector(point: gate.position).distanceTo(CGVector(point: enemyPosition))
            
            if(dist > CGFloat(TileMapSettings.TileSize))
            {
                continue
            }
            else if closestGate == nil
            {
                closestGate = gate
                closestDistance = dist
                continue
            }
            else if dist < closestDistance!
            {
                closestGate = gate
                closestDistance = dist
            }
        }
        return closestGate
    }
}
