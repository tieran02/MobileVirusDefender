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
    @IBOutlet weak var PuzzleViewContainer: UIView!
    @IBOutlet weak var PuzzleView: UIView!
    @IBOutlet weak var FacilityHealthBar: UIProgressView!
    @IBAction func QuitButtonTouched(_ sender: Any) {
        closePuzzleView()
    }
    @IBOutlet weak var TurretButton: UIButton!
    @IBAction func TurretButtonPressed(_ sender: Any)
    {
        self.currentGame?.PlaceTurretAtPlayerPosition()
    }
    @IBOutlet weak var PauseButton: UIButton!
    @IBAction func PauseButtonPressed(_ sender: Any)
    {
        if(PauseView.isHidden){
            pauseGame(paused: true)
        }
        else{
            pauseGame(paused: false)
        }
    }
    @IBAction func ContinueButtonPressed(_ sender: Any)
    {
        pauseGame(paused: false)
    }
    @IBAction func ExitButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var PauseView: UIView!
    @IBOutlet weak var GameOverView: UIView!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    @IBOutlet weak var ResearchPointLabel: UILabel!
    @IBOutlet weak var WaveLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PuzzleViewContainer.isHidden = true
        PauseView.isHidden = true
        GameOverView.isHidden = true
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let sceneNode = GameScene(fileNamed: "GameScene") {

            currentGame = sceneNode
            sceneNode.viewController = self
            
            // Set the scale mode to scale to fit the window
            sceneNode.scaleMode = .aspectFill

            // Present the scene
            if let view = self.view as! SKView? {
                view.presentScene(sceneNode)
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                //view.showsPhysics = true
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscapeRight
        } else {
            return .landscapeRight
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadPuzzleScene(sceneName : String, completeDelegate: ((Bool) -> Void)? )
    {
        if(self.PuzzleViewContainer.isHidden == false)
        {
            return
        }
        if(self.PuzzleViewContainer.superview == nil)
        {
            view.addSubview(self.PuzzleViewContainer)
        }
        
        PuzzleViewContainer.isHidden = false
        
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
                    view.isHidden = false
                }
            }
        }
    }
    
    func pauseGame(paused : Bool)
    {
        if(paused)
        {
            currentGame?.Pause(pause: true)
            PauseView.isHidden = false
        }
        else{
            currentGame?.Pause(pause: false)
            PauseView.isHidden = true
        }
    }
    

    func closePuzzleView()
    {
        if let view = self.PuzzleView as! SKView?
        {
            if let puzzle = view.scene as? IPuzzle
            {
                PuzzleViewContainer.isHidden = true
                puzzle.exit(completed: false)
            }
        }
    }
    
    func Gameover(score : Int)
    {
        PauseButton.isEnabled = false
        TurretButton.isEnabled = false
        ScoreLabel.text = "Score: \(score)"
        GameOverView.isHidden = false
        currentGame?.Pause(pause: true)
        
        //save highscore to core data
        ScoreboardHelper.UpdateScore(score: Int32(score))
    }

}
