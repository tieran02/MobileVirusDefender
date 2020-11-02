//
//  Joystick.swift
//  MobileVirusDefender
//
//  Created by Tieran on 29/10/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//
import Foundation
import SpriteKit

class Joystick : SKNode
{
    private var outerPad : SKSpriteNode;
    private var innerPad : SKSpriteNode;
    private let scale : CGFloat = 4.0
    
    
    public var IsTracking : Bool = false
    
    private var _direction : CGVector = CGVector(dx: 0, dy: 0)
    var Direction : CGVector {
        get{
            return _direction
        }
    }
    
    override init() {
        outerPad = SKSpriteNode(imageNamed: "OuterPad")
        innerPad = SKSpriteNode(imageNamed: "CenterPad")
        
        super.init()
        
        outerPad.zPosition = 1
        outerPad.setScale(scale)
        outerPad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(outerPad)
        
        innerPad.zPosition = 1.5
        innerPad.setScale(scale)
        innerPad.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(innerPad)
        
        self.isUserInteractionEnabled = true

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(!IsTracking)
        {
            for touch in touches {
                let touchPoint : CGPoint = touch.location(in: self)

                if(innerPad.contains(touchPoint))
                {
                    IsTracking = true
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if IsTracking
        {
            for touch in touches
            {
                let touchPoint : CGPoint = touch.location(in: self)
                innerPad.position = touchPoint
                
                let radius = outerPad.frame.width/2
                let origin = CGPoint(x:0,y:0)
                let dist : CGFloat = distance(touchPoint, origin)
                
                if(dist > radius)
                {
                    let originToObject = CGPoint(x: touchPoint.x * (radius/dist),y: touchPoint.y * (radius/dist))
                    innerPad.position = originToObject
                }
                
                _direction = CGVector(dx: innerPad.position.x / radius, dy: innerPad.position.y / radius)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        IsTracking = false
        innerPad.position = CGPoint(x: 0, y: 0)
        _direction = CGVector(dx: 0, dy: 0)
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    
    //MARK: encoder related methods
    required init?(coder aDecoder: NSCoder) {
        outerPad = aDecoder.decodeObject(forKey: "outerPad") as! SKSpriteNode
        innerPad = aDecoder.decodeObject(forKey: "innerPad") as! SKSpriteNode
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder){
        aCoder.encode(outerPad, forKey: "outerPad")
        aCoder.encode(innerPad, forKey: "innerPad")
    }
}
