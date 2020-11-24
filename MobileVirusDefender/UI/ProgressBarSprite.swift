//
//  ProgressBarSprite.swift
//  MobileVirusDefender
//
//  Created by Tieran on 24/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class ProgressBarSprite : SKNode
{
    var Track : SKSpriteNode?
    var Bar : SKSpriteNode?
    var progress : CGFloat = 0
    
    var Progress : CGFloat
    {
        get
        {
            return progress
        }
        set
        {
            let value = max(min(newValue,1.0),0.0)
            if let bar = Bar
            {
                bar.xScale = value
                progress = value
            }
        }
    }
    
    convenience init(color:SKColor, size:CGSize)
    {
            self.init()
            Track = SKSpriteNode(color:SKColor.white,size:size)
            Bar = SKSpriteNode(color:color,size:size)
            if let bar = Bar, let track = Track {
                bar.xScale = 0.0
                bar.zPosition = 1.0
                bar.position = CGPoint(x:-size.width/2,y:0)
                bar.anchorPoint = CGPoint(x:0.0,y:0.5)
                addChild(track)
                addChild(bar)
            }
        }
}
