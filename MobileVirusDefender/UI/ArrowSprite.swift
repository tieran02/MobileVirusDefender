//
//  ArrowSprite.swift
//  MobileVirusDefender
//
//  Created by Tieran on 24/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class ArrowSprite : SKSpriteNode
{
    var targetPoint : CGPoint?
    
    convenience init()
    {
        self.init(texture: SKTexture(imageNamed: "RedArrow"))
        //texture = SKTexture(imageNamed: "collider")
        size = CGSize(width: 128, height: 128)
        zPosition = 200
        
        isUserInteractionEnabled = false
    }
    
    func clampToRadius(scene: SKScene, originPoint : CGPoint, targetPoint : CGPoint, radius : CGFloat)
    {
        //convet point to view
        let orginView = CGVector(point: scene.convertPoint(toView: originPoint))
        //convet target to view
        let targetView = CGVector(point: scene.convertPoint(toView: targetPoint))
        
        //get distance
        let distance = targetView.distanceTo(orginView)
        
        if(distance > radius)
        {
            var originToTarget = targetView - orginView
            originToTarget *= radius / distance
            
            //convert back to scene space
            let scenePosition = scene.convertPoint(fromView: CGPoint(vector: orginView + originToTarget))
            self.position = scenePosition
            
            //get direction from 0,0
            let angle = (CGVector(point:targetPoint) - CGVector(point: scenePosition)).normalized().angle()
            zRotation = angle
        }
    }
    
    func clampToView(scene : SKScene, scenePoint : CGPoint, targetPoint : CGPoint)
    {
        //convet point to view
        let viewPoint = scene.convertPoint(toView: scenePoint)
        
        //clamp viewpoint
        let clampedX = min(max(viewPoint.x, 32), scene.view!.frame.width-32)
        let clampedY = min(max(viewPoint.y, 32), scene.view!.frame.height-32)
        //print("x \(clampedX) y \(clampedY)")
        
        //convert back to scene space
        let clampedScene = scene.convertPoint(fromView: CGPoint(x: clampedX, y: clampedY))
        self.position = clampedScene
        
        //get direction from 0,0
        let angle = (CGVector(point:clampedScene) - CGVector(point: targetPoint)).normalized().angle()
        zRotation = angle
    }
}
