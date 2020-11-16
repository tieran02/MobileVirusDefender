//
//  WirePuzzleScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 16/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion


class WirePuzzleScene: SKScene
{
    weak var viewController: GameViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    

    override func didMove(to view: SKView)
    {
        
    }
}
