//
//  LeverPuzzleScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 24/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class LeverPuzzleScene: SKScene, IPuzzle
{
    weak var viewController: GameViewController?
    var onCompleteDelegate: ((Bool) -> Void)?
    
    var startingPoint : CGPoint?
    var lever : SKNode?
    var activationPoint : SKNode?
    var dragging : Bool = false
    
    override func didMove(to view: SKView)
    {
        //pause game
        if let gameView = self.view?.superview?.superview as! SKView?
        {
            gameView.scene?.speed = 0
            gameView.scene?.physicsWorld.speed = 0
        }

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
        self.view!.addGestureRecognizer(gestureRecognizer)
        
        //get lever and activation point
        for child in children {
            if let node = child.userData?.value(forKey: "lever")
            {
                lever = child
                startingPoint = lever?.position
            }
            
            if let node = child.userData?.value(forKey: "activationPoint")
            {
                activationPoint = child
            }
        }
    }
    
    @objc func handlePanFrom(_ recognizer: UIPanGestureRecognizer)
    {
        var touchLocation = recognizer.location(in: recognizer.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        
        if recognizer.state == .began
        {
            if lever?.contains(touchLocation) ?? false
            {
                dragging = true
            }
        }
        
        if recognizer.state == .changed && dragging
        {
            let translation  = recognizer.translation(in: self.view)
            lever?.position = CGPoint(x: lever!.position.x, y: touchLocation.y)
        }
        
        if(recognizer.state == .ended)
        {
            if activationPoint?.contains(touchLocation) ?? false
            {
                exit(completed: true)
            }
            
            lever?.position = startingPoint!
        }
    }

    func setCompleteDelegate(completeDelegate:((Bool) -> Void)?)
    {
        onCompleteDelegate = completeDelegate
    }
    
    func exit(completed: Bool) -> Void
    {
        onCompleteDelegate?(completed)
        
        //unpause game
        if let gameView = self.view?.superview?.superview as! SKView?
        {
            gameView.scene?.speed = 1
            gameView.scene?.physicsWorld.speed = 1
        }
        
        self.view?.superview?.isHidden = true
    }
    
    
}
