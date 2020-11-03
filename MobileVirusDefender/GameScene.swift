//
//  GameScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 29/10/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    weak var viewController: GameViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var sceneCamera : SKCameraNode?
    
    private var lastUpdateTime : TimeInterval = 0
    

    override func didMove(to view: SKView)
    {
        sceneCamera = childNode(withName: "SKCameraNode") as? SKCameraNode
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        let leftDirection = viewController?.LeftJoystick.Direction
        if(sceneCamera != nil && leftDirection != nil)
        {
            let speed: CGFloat = 2000.0
            let currentPos = sceneCamera!.position;
            sceneCamera!.position = CGPoint(x: currentPos.x + (leftDirection!.dx * speed * CGFloat(dt)),
                                       y: currentPos.y + (leftDirection!.dy * speed * CGFloat(dt)))
            
            print(sceneCamera!.position)
        }
        //print(leftJoystick.Direction)
        
        self.lastUpdateTime = currentTime
    }
}
