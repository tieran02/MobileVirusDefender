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
    
    var ConnectionPoints = [SKSpriteNode]()
    var tempLine = SKShapeNode()
    var lineDictionary = [String : SKShapeNode]()
    
    override func didMove(to view: SKView)
    {
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
    
    func getConnectionFromTouchPosition(point : CGPoint) -> SKSpriteNode?
    {
        let touchedNodes = self.nodes(at: point)
        
        for node in touchedNodes
        {
            if let spriteNode = node as? SKSpriteNode
            {
                if let connection = ConnectionPoints.first(where: {$0 == spriteNode})
                {
                    return connection
                }
            }
        }
        return nil
    }
    
    var startConnection : SKSpriteNode?
    var endConnection : SKSpriteNode?
    @objc func handlePanFrom(_ recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == .began
        {
            var touchLocation = recognizer.location(in: recognizer.view)
            touchLocation = self.convertPoint(fromView: touchLocation)

            startConnection = getConnectionFromTouchPosition(point: touchLocation)
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

            endConnection = getConnectionFromTouchPosition(point: touchLocation)
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
