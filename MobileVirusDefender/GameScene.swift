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
    private var lastUpdateTime: TimeInterval = 0
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var sceneCamera : SKCameraNode?
    var Player : PlayerEntity = PlayerEntity(position: CGPoint(x:-9 * TileMapSettings.TileSize,y:-3 * TileMapSettings.TileSize))
    var ProjectilePool = EntityPool<ProjectileEntity>(entity: ProjectileEntity(lifeTime: 5), Amount: 100)
    var PlaceableTurretPool = EntityPool<PlaceableTurret>(entity: PlaceableTurret(), Amount: 10)
    var Spawners : [SpawnerEntity]?
    var Turrets : [TurretEntity]?
    var ResearchFacility : ResearchEntity?
    
    var pathfinding : PathFinding?
    
    private var researchPoints : Int = 0
    var ResearchPoint : Int
    {
        get{ return researchPoints}
        set
        {
            researchPoints = newValue
            if let researchPointLabel = viewController?.ResearchPointLabel
            {
                researchPointLabel.text = String(self.researchPoints)
            }
        }
    }
    
    var motionManager = CMMotionManager()

    override func didMove(to view: SKView)
    {
        sceneCamera = childNode(withName: "SKCameraNode") as? SKCameraNode
        addChild(Player)
        AddTileMapColliders()
        
        Spawners = children.compactMap{ $0 as? SpawnerEntity}
        Turrets = children.compactMap{ $0 as? TurretEntity}
        ResearchFacility = children.compactMap{ $0 as? ResearchEntity}.first
        
        pathfinding = PathFinding(scene: self, nodesPerUnit: 1, unitSize: 256, unitColumns: 64, unitRows: 64)
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
        
        //setup notifcation for pause when app enters the background
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Pause"), object: nil, queue: OperationQueue.main) { (paused) in
            self.Pause(pause : paused.object as! Bool)
        }
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = Float(currentTime - self.lastUpdateTime)
 
        let leftDirection = viewController?.LeftJoystick.Direction
        let rightDirection = viewController?.RightJoystick.Direction
        
        if(leftDirection!.lengthSquared() > 0.0 || rightDirection!.lengthSquared() > 0.0)
        {
            viewController?.closePuzzleView()
        }
        
        if(sceneCamera != nil)
        {
            PlaceableTurretPool.Update(deltaTime: dt, scene: self)
            Turrets?.forEach{ $0.Update(deltaTime: dt, scene: self)}
            Spawners?.forEach{ $0.Update(deltaTime: dt, scene: self)}
            ResearchFacility?.Update(deltaTime: dt, scene: self)
            Player.Update(deltaTime: dt, scene: self)
            ProjectilePool.Update(deltaTime: dt, scene: self)
            sceneCamera?.position = Player.position
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func Pause(pause : Bool)
    {
        isPaused = pause
        lastUpdateTime = 0
    }
    
    func AddTileMapColliders()
    {
        for child in children {
            if child.userData?.value(forKey: "colliderMap") as? Int == nil
            {
                continue
            }
        
            guard let tileMap = child as? SKTileMapNode
                else { fatalError("Child is not of type SKTileMapNode") }
            
            //get category from user details for collisions
            let mask = tileMap.userData?.value(forKey: "physicsCategory") as? UInt32 ?? PhysicsMask.Envioment.rawValue
            
            
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
                        
                        //physics bodies
                        let rects = rectsFromUserData(userData: tileDefinition?.userData)
                        for rect in rects
                        {
                            let node = SKNode()
                            //node.position = CGPoint(x: x, y: y)
                            let body : SKPhysicsBody = SKPhysicsBody(rectangleOf: rect.size, center: CGPoint(x:rect.midX,y:rect.midY))
                            body.isDynamic = false
                            
                            body.collisionBitMask = PhysicsMask.All.rawValue
                            //body.contactTestBitMask = PhysicsMask.All.rawValue
                            body.categoryBitMask = mask
                            
                            node.physicsBody = body
                            tileNode.addChild(node)
                        }
                        
                        tileNode.position = CGPoint(x: x, y: y)

                        tileMap.addChild(tileNode)
                        
                        //let test = boundingBoxFromTexture(texture: (tileDefinition?.textures[0])!)
                    }
                }
            }
        }
    }
    
    func rectsFromUserData(userData : NSMutableDictionary?) -> [CGRect]
    {
        if(userData == nil)
        {
            return [CGRect]()
        }
        
        var rects = [String : (Int,Int,Int,Int)]()
        
        for data in userData!
        {
            let splitData : [Substring]? = (data.key as? String)?.split(separator: "_")
            
            if(splitData == nil || splitData!.count < 2){
                continue
            }

            let indexString = String(splitData![0])
            let rectString = String(splitData![1])
            
            if(rects[indexString] == nil)
            {
                rects[indexString] = (Int,Int,Int,Int)(0,0,0,0)
            }
            
            switch rectString
            {
                case "colliderX":
                    rects[indexString]!.0 = data.value as! Int
                    break
                case "colliderY":
                    rects[indexString]!.1 = data.value as! Int
                    break
                case "colliderWidth":
                    rects[indexString]!.2 = data.value as! Int
                    break
                case "colliderHeight":
                    rects[indexString]!.3 = data.value as! Int
                    break
                default:
                    break
            }
        }
        
        var cgRects = [CGRect]()
        
        if(rects.count > 1)
        {
            print("Test")
        }
        
        for rect in rects {
            cgRects.append(CGRect(x: rect.value.0, y: rect.value.1, width: rect.value.2, height: rect.value.3))
        }
        
        return cgRects
    }
    
    func PlaceTurretAtPlayerPosition()
    {
        let turret = PlaceableTurretPool.Retrieve()
        
        if(turret != nil)
        {
            turret!.position = Player.position
            turret!.Reset()
            addChild(turret!)
        }
    }
    
    func completePuzzle(completed : Bool)
    {
        print("Have completed puzzle \(completed)")
    }
}
