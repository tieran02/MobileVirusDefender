//
//  MicroscopePuzzleScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 28/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
import CoreMotion

class MicroscopePuzzleScene : SKScene, IPuzzle
{
    weak var viewController: GameViewController?
    var onCompleteDelegate: ((Bool) -> Void)?

    let ResearchGain : Int = 50
    
    var motionManager = CMMotionManager()
    
    var virus : SKNode?
    var microscope : SKNode?
    var virusAttitudePoint = CGPoint(x: 0, y: 0)
    
    let minYaw : CGFloat = -1.5
    let maxYaw : CGFloat = 1.5
    let minRoll : CGFloat = -1.5
    let maxRoll : CGFloat = 1.5
    
    let minStartRoll : CGFloat = -2.0
    let maxStartRoll : CGFloat = -0.25
    
    let arrow = ArrowSprite()
 
    override func didMove(to view: SKView)
    {
        //pause game
        if let gameView = self.view?.superview?.superview as! SKView?
        {
            if let gameScene = gameView.scene as? GameScene{
                gameScene.Pause(pause: true)
            }
        }
        
        virusAttitudePoint = getRandomOrientationPoint()
        
        for child in children {
            if let node = child.userData?.value(forKey: "virus")
            {
                virus = child
                virus?.position = self.attitudeToWorld(yaw: virusAttitudePoint.x, roll: virusAttitudePoint.y)
                virus?.zPosition = 10
            }
            if let node = child.userData?.value(forKey: "microscope")
            {
                microscope = child
            }
        }
        
        
        //setup accelerometer
        if(motionManager.isAccelerometerAvailable)
        {
            motionManager.deviceMotionUpdateInterval = 1.0/60.0
            motionManager.startDeviceMotionUpdates(to: .main)
            {
                (data, error) in
                guard let data = data, error == nil else
                {
                    return
                }

                /*print("Pitch \(data.attitude.pitch)")
                print("Yaw \(data.attitude.yaw)")
                print("Roll \(data.attitude.roll)")
                print("Point \(self.virusAttitudePoint)")*/
                
                let offset = self.attitudeToWorld(yaw: self.virusAttitudePoint.x, roll: self.virusAttitudePoint.y)
                self.virus?.position = offset - self.attitudeToWorld(yaw: CGFloat(data.attitude.yaw), roll: CGFloat(data.attitude.roll))
                
                let centerPos = CGPoint(x: self.virus!.frame.midX, y: self.virus!.frame.midY)
                let centerRect = CGRect(x: -32, y: -32, width: 64, height: 64)
               
                
                if(self.microscope!.contains(centerPos))
                {
                    self.showDirectionalArrow(visible: false)
                }else{
                    self.showDirectionalArrow(visible: true)
                }
                
                //print("Center \(centerPos)")
                if centerRect.contains(centerPos)
                {
                    self.exit(completed: true)
                }
            }
        }
        
        
    }
      
    func setCompleteDelegate(completeDelegate:((Bool) -> Void)?)
    {
        onCompleteDelegate = completeDelegate
    }
    
    func exit(completed: Bool) -> Void
    {
        motionManager.stopDeviceMotionUpdates()
        
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
    
    func getRandomOrientationPoint() -> CGPoint
    {
        let rand01 : CGFloat = CGFloat(arc4random()) / 0xFFFFFFFF
        
        
        let x = rand01 * (maxYaw - minYaw) + minYaw
        let y = rand01 * (maxStartRoll - minStartRoll) + minStartRoll
        return CGPoint(x: x, y: y)
    }
    
    func attitudeToWorld(yaw : CGFloat, roll : CGFloat) -> CGPoint
    {
        let worldSize = view!.bounds.size
        let normlisedYaw : CGFloat = (yaw-minYaw) / (maxYaw - minYaw)
        let normlisedRoll : CGFloat = (roll-minRoll) / (maxRoll - minRoll)
        
        let x = worldSize.width * normlisedYaw
        let y = worldSize.height * normlisedRoll
        
        return CGPoint(x: x, y: y);
    }
    
    func showDirectionalArrow(visible : Bool)
    {
        if(arrow.parent == nil && visible)
        {
            addChild(arrow)
        }
        
        if(visible)
        {
            arrow.clampToRadius(scene: self, originPoint: microscope!.position, targetPoint: virus!.position, radius: (microscope!.frame.width*0.5)-128)
        }
        else
        {
            arrow.removeFromParent()
        }

    }
    
}
