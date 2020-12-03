//
//  TestTubePuzzleScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 26/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
import CoreMotion

class TestTubePuzzleScene : SKScene, IPuzzle
{
    weak var viewController: GameViewController?
    var onCompleteDelegate: ((Bool) -> Void)?

    let ResearchGain : Int = 50
    
    var motionManager = CMMotionManager()
    var time : Float = 0
    var tube : SKNode?
    
    let EndTarget = CGPoint(x:68,y:183)
    var StartPoint = CGPoint(x:0,y:0)
    
    let startRotation : CGFloat = 0
    let endRotation : CGFloat = -110
    
    let TubeCrop = SKCropNode()
    
    override func didMove(to view: SKView)
    {
        //pause game
        if let gameView = self.view?.superview?.superview as! SKView?
        {
            if let gameScene = gameView.scene as? GameScene{
                gameScene.Pause(pause: true)
            }
        }
        
        
        TubeCrop.zPosition = 1
        let shape = SKShapeNode(rectOf: CGSize(width: 256, height: 256))
        shape.fillColor = UIColor.black
        let texture = view.texture(from: shape)
        TubeCrop.maskNode = SKSpriteNode(texture: texture)
        //get tube and flask point
        for child in children {
            if (child.userData?.value(forKey: "tube")) != nil
            {
                tube = child
                tube?.addChild(TubeCrop)
                StartPoint = tube!.position
            }
        }
        
        //setup accelerometer
        if(motionManager.isAccelerometerAvailable)
        {
            motionManager.deviceMotionUpdateInterval = 1.0/60.0
            motionManager.startDeviceMotionUpdates(to: .main)
            {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }

                let clamped = min(max(data.attitude.pitch, 0), 1)
                self.time = Float(clamped)

                
                let actualPoint = CGPoint(x: clamped, y: clamped).lerp(min: self.StartPoint, max: self.EndTarget)
                self.tube?.position = actualPoint
                
                let actualRotation = CGFloat(clamped).lerp(min: self.startRotation, max: self.endRotation)
                self.tube?.zRotation = actualRotation * CGFloat.pi / 180
                
                self.TubeCrop.yScale = CGFloat(clamped)
                if(clamped >= 1)
                {
                    self.exit(completed: true)
                }
            }
        }
        
        
    }
    
    func getActionTiming() -> Float
    {
        return time
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
}
