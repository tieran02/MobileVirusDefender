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

protocol IPuzzle {
    func exit(completed : Bool) -> Void
    func setCompleteDelegate(completeDelegate: ((Bool) -> Void)?)
}

class WirePuzzleScene: SKScene, IPuzzle
{
    weak var viewController: GameViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var onCompleteDelegate: ((Bool) -> Void)?
    
    override func didMove(to view: SKView)
    {
        
    }
    
    func setCompleteDelegate(completeDelegate:((Bool) -> Void)?)
    {
        onCompleteDelegate = completeDelegate
    }
    
    func exit(completed: Bool) -> Void
    {
        onCompleteDelegate?(completed)
        
        self.view?.removeFromSuperview()
    }
    
}
