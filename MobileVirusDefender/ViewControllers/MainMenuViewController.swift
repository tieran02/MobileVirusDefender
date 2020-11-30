//
//  MainMenuViewController.swift
//  MobileVirusDefender
//
//  Created by Tieran on 30/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit

class MainMenuViewController : UIViewController
{
    override func viewDidLoad()
    {
        GlobalSoundManager.PlayMusicSound(filename: "background",ofType: "wav")
    }
}
