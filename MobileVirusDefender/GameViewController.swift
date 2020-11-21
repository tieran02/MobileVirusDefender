//
//  GameViewController.swift
//  MobileVirusDefender
//
//  Created by Tieran on 29/10/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    var popupScene : SKScene?
    
    @IBOutlet weak var LeftJoystick: JoystickUI!
    @IBOutlet weak var RightJoystick: JoystickUI!
    @IBOutlet weak var PuzzleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                sceneNode.viewController = self
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill

                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadPuzzleScene(sceneName : String, completeDelegate: ((Bool) -> Void)? )
    {
        // Load 'WirePuzzleScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: sceneName) {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! SKScene? {
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFit
                
                if let puzzle = sceneNode as? IPuzzle
                {
                    puzzle.setCompleteDelegate(completeDelegate: completeDelegate)
                }
                
                // Present the scene
                if let view = self.PuzzleView as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    func closePuzzleView()
    {
        if let view = self.PuzzleView as! SKView?
        {
            if let puzzle = view.scene as? IPuzzle
            {
                puzzle.exit(completed: false)
            }
        }
    }
}
