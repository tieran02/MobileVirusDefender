//
//  Util.swift
//  MobileVirusDefender
//
//  Created by Tieran on 15/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import Foundation

struct TileMapSettings
{
    static let TileSize : Int = 256
}

struct PhysicsMask: OptionSet {

    let rawValue: UInt32

    static let Envioment            = PhysicsMask(rawValue: 1 << 0)
    static let Player               = PhysicsMask(rawValue: 1 << 2)
    static let PlayerProjectile     = PhysicsMask(rawValue: 1 << 3)
    static let Enemy                = PhysicsMask(rawValue: 1 << 4)
    static let EnemyProjectile      = PhysicsMask(rawValue: 1 << 5)
    
    static let All: PhysicsMask     = [.Player, .PlayerProjectile, .Enemy, .EnemyProjectile]
}

