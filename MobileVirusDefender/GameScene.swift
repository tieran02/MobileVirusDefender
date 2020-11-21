//
//  GameScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 29/10/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreMotion

struct AccelerometerData
{
    let Acceleration : CMAcceleration
    let LastAcceleration : CMAcceleration
    
    var DeltaAcceleration : CMAcceleration
    {
        get
        {
            return CMAcceleration(x: Acceleration.x - LastAcceleration.x, y: Acceleration.y - LastAcceleration.y, z: Acceleration.z - LastAcceleration.z)
        }
    }
    
    init(acceleration : CMAcceleration, lastAcceleration : CMAcceleration) {
        Acceleration = acceleration
        LastAcceleration = lastAcceleration
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewController: GameViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var sceneCamera : SKCameraNode?
    var Player : PlayerEntity = PlayerEntity(position: CGPoint(x:-9 * TileMapSettings.TileSize,y:1 * TileMapSettings.TileSize))
    var Enemy : EnemyEntity = EnemyEntity(position: CGPoint(x:5 * TileMapSettings.TileSize,y:5 * TileMapSettings.TileSize))
    var ProjectilePool = EntityPool<ProjectileEntity>(entity: ProjectileEntity(lifeTime: 5), Amount: 100)
    
    var pathfinding : PathFinding?
    
    var motionManager = CMMotionManager()
    private var lastUpdateTime : TimeInterval = 0    

    override func didMove(to view: SKView)
    {
        sceneCamera = childNode(withName: "SKCameraNode") as? SKCameraNode
        addChild(Player)
        addChild(Enemy)
        AddTileMapColliders()
        
        guard let tileMap = childNode(withName: "Colliders") as? SKTileMapNode
            else { fatalError("Missing tile map for the colliders") }
        pathfinding = PathFinding(tilemap: tileMap)
        //pathfinding?.DrawNodes(scene: self)
        
        physicsWorld.contactDelegate = self
        
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

                self.Player.Acceleration(acceleration: data.userAcceleration,scene: self)
            }
        }
        
        //setup puzzle delegate
        viewController?.loadPuzzleScene(sceneName: "WirePuzzleScene", completeDelegate: completePuzzle)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        // Handle the collitions in each nodes class
       
        if let entity = contact.bodyA.node as? BaseEntity
        {
            entity.collisionBegan(with: contact.bodyB)
        }
       
        if let entity = contact.bodyB.node as? BaseEntity
        {
            entity.collisionBegan(with: contact.bodyA)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //viewController?.closePuzzleView()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
         
        let leftDirection = viewController?.LeftJoystick.Direction
        let rightDirection = viewController?.RightJoystick.Direction
        
        if(leftDirection!.lengthSquared() > 0.0 || rightDirection!.lengthSquared() > 0.0)
        {
            viewController?.closePuzzleView()
        }
        
        if(sceneCamera != nil)
        {
            Player.Update(deltaTime: Float(dt), scene: self)
            Enemy.Update(deltaTime: Float(dt), scene: self)
            ProjectilePool.Update(deltaTime: Float(dt), scene: self)
            sceneCamera?.position = Player.position
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func AddTileMapColliders()
    {
        guard let tileMap = childNode(withName: "Colliders") as? SKTileMapNode
            else { fatalError("Missing tile map for the colliders") }
        
        let tileSize = tileMap.tileSize;
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                if (tileDefinition != nil) {
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.collisionBitMask = PhysicsMask.All.rawValue
                    tileNode.physicsBody?.contactTestBitMask = PhysicsMask.All.rawValue
                    tileNode.physicsBody?.categoryBitMask = PhysicsMask.Envioment.rawValue
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
    
    func completePuzzle(completed : Bool)
    {
        print("Have completed puzzle \(completed)")
    }
}
