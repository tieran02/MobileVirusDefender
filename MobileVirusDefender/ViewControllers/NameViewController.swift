//
//  NameViewController.swift
//  MobileVirusDefender
//
//  Created by Tieran on 02/12/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit

class NameViewController : UIViewController
{
    @IBOutlet weak var NameTextField: UITextField!
    @IBAction func SubmitNamePressed(_ sender: Any)
    {
        if let name = NameTextField.text
        {
            SetName(name: name)
            
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
            guard let destinationViewController = mainStoryBoard.instantiateViewController(identifier: "MainMenuViewController") as? MainMenuViewController
            else {
                return
            }
            //performSegue(withIdentifier: "MainMenuViewController", sender: nil)
            
            destinationViewController.modalPresentationStyle = .fullScreen
            present(destinationViewController, animated: true, completion: nil)
            //navigationController?.pushViewController(destinationViewController, animated: true)
        }
        
        
    }
    
    func validateName(name : String) -> Bool
    {
        return name.count >= 3
    }
    
    func SetName(name : String)
    {
        ScoreboardHelper.SetPlayerName(name: name)
    }
}
