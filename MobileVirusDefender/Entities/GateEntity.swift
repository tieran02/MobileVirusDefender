//
//  GateEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 24/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class GateEntity : BaseEntity
{
    let arrow = ArrowSprite()
    
    let GateOpenTexture : SKTexture = SKTexture(imageNamed: "gateOpen")
    let GateClosedexture : SKTexture = SKTexture(imageNamed: "gateClosed")
    
    private var open = false
    var Open : Bool
    {
        get
        {
            return open
        }
        set
        {
            open = newValue
            if open
            {
                texture = GateOpenTexture
                physicsBody?.categoryBitMask = 0
            }
            else
            {
                texture = GateClosedexture
                physicsBody?.categoryBitMask = PhysicsMask.Walls.rawValue
                Heal(amount: MaxHealth)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup()
    {
        super.setup()
        self.isUserInteractionEnabled = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsMask.Walls.rawValue
        
        //hide healthbar
        HealthBar.isHidden = true
        
        Open = true
        
    }
    
    override func Destroy()
    {
        Open = true
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if open, let gameScene = scene as? GameScene
        {
            //setup puzzle delegate
            gameScene.viewController?.loadPuzzleScene(sceneName: "LeverPuzzleScene", completeDelegate: completePuzzle)
        }
    }
    
    func showDirectionalArrow(scene : GameScene, visible : Bool)
    {
        if(arrow.parent == nil && visible)
        {
            scene.addChild(arrow)
        }
        
        if(visible)
        {
            arrow.clampToView(scene: scene, scenePoint: position, targetPoint: scene.Player.position)
        }
        else
        {
            arrow.removeFromParent()
        }

    }
    
    func completePuzzle(completed : Bool)
    {
        if(completed)
        {
            Open = false
        }
    }
}
