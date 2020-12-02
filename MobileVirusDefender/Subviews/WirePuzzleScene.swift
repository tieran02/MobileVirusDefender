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
    var onCompleteDelegate: ((Bool) -> Void)?
    
    let ResearchGain : Int = 5
    var ConnectionPoints = [SKSpriteNode]()
    var tempLine = SKShapeNode()
    var lineDictionary = [String : SKShapeNode]()
    
    override func didMove(to view: SKView)
    {
        //pause game
        if let gameView = self.view?.superview?.superview as! SKView?
        {
            if let gameScene = gameView.scene as? GameScene{
                gameScene.Pause(pause: true)
            }
        }
        
        AddConnectionFromName(withName: "LeftRedNode")
        AddConnectionFromName(withName: "LeftYellowNode")
        AddConnectionFromName(withName: "LeftGreenNode")
        AddConnectionFromName(withName: "LeftBlueNode")
        AddConnectionFromName(withName: "RightRedNode")
        AddConnectionFromName(withName: "RightYellowNode")
        AddConnectionFromName(withName: "RightGreenNode")
        AddConnectionFromName(withName: "RightBlueNode")
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
        self.view!.addGestureRecognizer(gestureRecognizer)
    }
    
    func AddConnectionFromName(withName: String)
    {
        if let connection = self.childNode(withName: withName) as? SKSpriteNode
        {
            ConnectionPoints.append(connection)
        }
        
    }
        
    var startConnection : SKSpriteNode?
    var endConnection : SKSpriteNode?
    @objc func handlePanFrom(_ recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == .began
        {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)

            let connection = getClosestConnection(touchPoint: touchLocation, range: 96)
            if connection != nil && !lineConnected(connectionNode: connection!)
            {
                startConnection = connection
            }
        }
        
        if(startConnection == nil)
        {
            return
        }
        
        if recognizer.state == .changed
        {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)

            drawLine(from: startConnection!.position, to: touchLocation)
        }
        
        if recognizer.state == .ended
        {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)

            endConnection = getClosestConnection(touchPoint: touchLocation, range: 96)
            if(endConnection == nil)
            {
                tempLine.removeFromParent()
                return
            }
            
            //matched nodes add line to dictionary
            if let startColor = startConnection!.userData?.value(forKey: "color") as? String
            {
                if let endColor = endConnection!.userData?.value(forKey: "color") as? String
                {
                    if startColor == endColor && lineDictionary[startColor] == nil
                    {
                        let lineCopy = tempLine.copy() as! SKShapeNode
                        addChild(lineCopy)
                        lineDictionary[endColor] = lineCopy
                    }
                }
            }
            
            //check if point are connected by counting how many lines
            if(lineDictionary.count == 4)
            {
                exit(completed: true)
            }
            
            tempLine.removeFromParent()
            startConnection = nil
            endConnection = nil
        }
        
        if(endConnection == nil || startConnection == endConnection)
        {
            return
        }
                
    }

    func drawLine(from: CGPoint, to: CGPoint){
        tempLine.removeFromParent()
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        tempLine = SKShapeNode(path: path)
        self.addChild(tempLine)
    }
    
    func getClosestConnection(touchPoint : CGPoint, range: CGFloat) -> SKSpriteNode?
    {
        for connection in ConnectionPoints
        {
            let distanceFromTouch = touchPoint.distanceTo(connection.position)
            if distanceFromTouch <= range
            {
                return connection
            }
        }
        return nil
    }
    
    func lineConnected(connectionNode : SKSpriteNode) -> Bool
    {
        if let color = connectionNode.userData?.value(forKey: "color") as? String
        {
            return lineDictionary[color] != nil
        }
        return false
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
            if let gameScene = gameView.scene as? GameScene{
                gameScene.Pause(pause: false)
            }
            
            if(completed)
            {
                if let gameScene = gameView.scene as? GameScene{
                    gameScene.ResearchPoint += ResearchGain
                }
            }
        }
        
        self.view?.superview?.isHidden = true
    }
    
    
}
