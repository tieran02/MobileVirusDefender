//
//  AudioButton.swift
//  MobileVirusDefender
//
//  Created by Tieran on 02/12/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit
import AVFoundation

@IBDesignable
class AudioButton: UIButton
{
    var clickAudioPath : String?
    var clickAudioType : String?
    
    @IBInspectable var audioPath: String?{
        didSet{
            clickAudioPath = audioPath
        }
    }
    
    @IBInspectable var audioType: String?{
        didSet{
            clickAudioType = audioType
        }
    }

    override init(frame: CGRect) {
         super.init(frame: frame)
         setup()
     }

     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         setup()
     }

     override func prepareForInterfaceBuilder() {
         super.prepareForInterfaceBuilder()
         setup()
     }

     internal func setup() {
         self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
     }

     /// Called each time the button is tapped, and toggles the checked property
     @objc private func tapped() {
         //play audio
        if clickAudioPath != nil && clickAudioType != nil
        {
            GlobalSoundManager.PlaySound(filename: clickAudioPath!, ofType: clickAudioType!)
        }
     }
}
