//
//  GlobalSoundManager.swift
//  MobileVirusDefender
//
//  Created by Tieran on 30/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import AVFoundation

class GlobalSoundManager : NSObject, AVAudioPlayerDelegate
{
    private static var CurrentSounds = [String: AVAudioPlayer]()
    private static var CurrentMusic = [String: AVAudioPlayer]()
    
    private static var currentMusicVolume : Float = UserDefaults.standard.object(forKey: "musicVolume") as? Float ?? 1
    private static var currentEffectVolume : Float = UserDefaults.standard.object(forKey: "effectVolume") as? Float ?? 1
        
    static var MusicVolume : Float{
        get{
            return currentMusicVolume
        }
    }
    
    static var EffectVolume : Float{
        get{
            return currentEffectVolume
        }
    }
    
    static func PlaySound(filename : String, ofType : String)
    {
        if CurrentSounds[filename] != nil
        {
            CurrentSounds[filename]?.play()
            return
        }

        let path = Bundle.main.path(forResource: filename, ofType:ofType)!
        let url = URL(fileURLWithPath: path)
        
        do {
            CurrentSounds[filename] = try AVAudioPlayer(contentsOf: url)
            guard let player = CurrentSounds[filename] else { return }

            player.prepareToPlay()
            player.volume = currentEffectVolume
            player.play()
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    static func PlayMusicSound(filename : String, ofType : String, loopCount : Int)
    {
        if CurrentMusic[filename] != nil
        {
            return
        }
      
        let path = Bundle.main.path(forResource: filename, ofType:ofType)!
        let url = URL(fileURLWithPath: path)
        
        do {
            CurrentMusic[filename] = try AVAudioPlayer(contentsOf: url)
            guard let player = CurrentMusic[filename] else { return }

            player.prepareToPlay()
            player.volume = currentMusicVolume
            player.numberOfLoops = loopCount
            player.play()
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        print("Finish")
    }
    
    static func SetMusicVolume(volume : Float)
    {
        currentMusicVolume = volume
        UserDefaults.standard.set(volume, forKey: "musicVolume")
        for sound in CurrentMusic {
            sound.value.volume = currentMusicVolume
        }
    }
    
    static func SetEffectVolume(volume : Float)
    {
        currentEffectVolume = volume
        UserDefaults.standard.set(volume, forKey: "effectVolume")
        
        for sound in CurrentSounds {
            sound.value.volume = currentEffectVolume
        }
    }
}
