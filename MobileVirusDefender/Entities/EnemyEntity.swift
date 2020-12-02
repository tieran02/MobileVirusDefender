//
//  EnemyEntity.swift
//  MobileVirusDefender
//
//  Created by Tieran on 15/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

class EnemyEntity : BaseEntity
{
    var StateMachine : FiniteStateMachine?
    
    let AttackDamage : Float = 5
    let AttackRange : CGFloat = CGFloat(TileMapSettings.TileSize)
    
    let deathAudioNode = SKAudioNode(fileNamed: "Orc Death 3.mp3")
    let attackAudioNode = SKAudioNode(fileNamed: "Orc Attack Voice 4.mp3")
    
    init(position: CGPoint = CGPoint(x: 0,y: 0))
    {
        super.init(texture: SKTexture(imageNamed: "Idle_000"), maxHealth: 100, position: position)
        physicsBody?.categoryBitMask = PhysicsMask.Enemy.rawValue;
        physicsBody?.collisionBitMask = PhysicsMask([PhysicsMask.Envioment, PhysicsMask.Turret, PhysicsMask.Walls]).rawValue
        self.physicsBody?.linearDamping = 5
        Speed = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup()
    {
        size = CGSize(width: texture!.size().width * 0.6, height: texture!.size().height * 0.6)
        physicsBody = SKPhysicsBody(circleOfRadius: 64)
        super.setup()
        StateMachine = FiniteStateMachine(enemy: self)
        
        super.AnimationStateDictionary[AnimationState.Idle] = SKAction(named: "ZombieIdle")
        super.AnimationStateDictionary[AnimationState.Running] = SKAction(named: "ZombieRun")
        super.AnimationStateDictionary[AnimationState.Attacking] = SKAction(named: "ZombieAttack")
        super.AnimationStateDictionary[AnimationState.Dying] = SKAction(named: "ZombieDying")
        
        
        deathAudioNode.isPositional = true
        deathAudioNode.autoplayLooped = false
        addChild(deathAudioNode)
        //attackAudioNode.isPositional = true
        attackAudioNode.autoplayLooped = false
        addChild(attackAudioNode)
    }
    
    override func Update(deltaTime: Float, scene: GameScene)
    {
        super.Update(deltaTime: deltaTime, scene: scene)
        
        if(StateMachine?.currentState == nil)
        {
            StateMachine?.PushState(state: MoveToFacility(), scene: scene)
        }
        
        if(Velocity.dx >= 0)
        {
            xScale = 1
        }
        else
        {
            xScale = -1
        }
        
        StateMachine?.Update(deltaTime: deltaTime, scene: scene)
    }
    
    func Attack(entity : BaseEntity)
    {
        runAnimationState(state: AnimationState.Attacking)
        attackAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: GlobalSoundManager.EffectVolume, duration: 0)
                                               ,SKAction.play()]))
        
        entity.Damage(amount: AttackDamage)
    }
    
    func Reset()
    {
        Heal(amount: MaxHealth)
        runAnimationState(state: AnimationState.Idle)
    }

    override func Clone() -> BaseEntity {
        EnemyEntity(position: position)
    }
    
    override func Destroy()
    {
        if let gamescene = scene as? GameScene
        {
            gamescene.ResearchPoint += 1
        }
        
        //death sound
        deathAudioNode.run(SKAction.sequence([SKAction.changeVolume(to: GlobalSoundManager.EffectVolume, duration: 0),
                                              SKAction.play()]))
        
        super.Destroy()
        StateMachine?.Clear()
    }
    
}
