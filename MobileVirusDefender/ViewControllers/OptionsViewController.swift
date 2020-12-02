//
//  OptionsViewController.swift
//  MobileVirusDefender
//
//  Created by Tieran on 30/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit

class OptionsViewController : UIViewController
{
    @IBOutlet weak var EffectSlider: DesignAbleSlider!
    @IBOutlet weak var MusicSlider: DesignAbleSlider!
    @IBAction func MusicVolumeChanged(_ sender: DesignAbleSlider)
    {
        GlobalSoundManager.SetMusicVolume(volume: sender.value)
    }
    
    @IBAction func EffectVolumeChanged(_ sender: DesignAbleSlider)
    {
        GlobalSoundManager.SetEffectVolume(volume: sender.value)
    }
    
    @IBAction func ClearDataPressed(_ sender: Any)
    {
    }
    
    override func viewDidLoad() {
        EffectSlider.value = GlobalSoundManager.EffectVolume
        MusicSlider.value = GlobalSoundManager.MusicVolume
    }
}
