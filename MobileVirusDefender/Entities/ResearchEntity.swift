//
//  ResearchEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 23/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class ResearchEntity : BaseEntity
{
    var healthbar : UIProgressView?
    
    let PointGain : Int = 20
    let WaitTime : Float = 10
    var pointTimer : Float = 0
    
    let taskCooldown : Float = 60
    var taskTimer : Float = 0
    
    let arrow = ArrowSprite()
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "CenterPad"), maxHealth: 1000)
        setup()
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
        MaxHealth = 1000
        Heal(amount: MaxHealth)
        taskTimer = taskCooldown
        
        Destructable = true
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = PhysicsMask.Research.rawValue
        
        //hide healthbar
        HealthBar.isHidden = true
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        super.Update(deltaTime: deltaTime, scene: scene)
        
        if(taskTimer >= taskCooldown)
        {
            showDirectionalArrow(scene: scene, visible: true)
        }
        else
        {
            showDirectionalArrow(scene: scene, visible: false)
        }
        
        if(pointTimer >= WaitTime)
        {
            increaseResearch()
            pointTimer = 0
        }
        pointTimer += deltaTime
        taskTimer += deltaTime
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if taskTimer >= taskCooldown, let gameScene = scene as? GameScene
        {
            if(position.distanceTo(gameScene.Player.position) >= CGFloat(TileMapSettings.TileSize * 2))
            {
                return
            }
            
            switch Int.random(in: 0...1) {
            case 0:
                gameScene.viewController?.loadPuzzleScene(sceneName: "TestTubePuzzleScene", completeDelegate: completePuzzle)
                break
            case 1:
                gameScene.viewController?.loadPuzzleScene(sceneName: "MicroscopePuzzleScene", completeDelegate: completePuzzle)
            default:
                gameScene.viewController?.loadPuzzleScene(sceneName: "TestTubePuzzleScene", completeDelegate: completePuzzle)
            }
            
            taskTimer = 0
        }
    }
    
    override func Damage(amount: Float)
    {
        super.Damage(amount: amount)
        setHealthUI()
    }
    
    override func Destroy()
    {
        if let gamescene = scene as? GameScene
        {
            gamescene.viewController?.Gameover(score: gamescene.ResearchPoint)
        }
        super.Destroy()
    }
    
    func setHealthUI()
    {
        if let gameScene = scene as? GameScene
        {
            gameScene.viewController?.FacilityHealthBar?.progress = HealthPercentage()
        }
    }
    
    func increaseResearch()
    {
        if self.CurrentHealth > 0, let scene = self.scene as? GameScene
        {
            scene.ResearchPoint += PointGain
        }
    }
    
    func completePuzzle(completed : Bool)
    {
        if completed{
            let sound = SKAction.playSoundFileNamed("sci-fi_scan_target_01.wav", waitForCompletion: false)
            run(sound)
            
            Heal(amount: 0.05 * MaxHealth)
            setHealthUI()
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
}
