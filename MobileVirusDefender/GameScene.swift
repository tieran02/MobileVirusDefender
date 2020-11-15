//
//  GameScene.swift
//  MobileVirusDefender
//
//  Created by Tieran on 29/10/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    weak var viewController: GameViewController?
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var sceneCamera : SKCameraNode?
    var Player : PlayerEntity = PlayerEntity()
    
    private var lastUpdateTime : TimeInterval = 0
    

    override func didMove(to view: SKView)
    {
        sceneCamera = childNode(withName: "SKCameraNode") as? SKCameraNode
        addChild(Player)
        AddTileMapColliders()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

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
         
        if(sceneCamera != nil)
        {
            Player.Update(deltaTime: Float(dt), scene: self)
            sceneCamera?.position = Player.position
        }
        //print(leftJoystick.Direction)
        
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
                    tileNode.physicsBody?.categoryBitMask = PhysicsMask.Envioment.rawValue
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
}
