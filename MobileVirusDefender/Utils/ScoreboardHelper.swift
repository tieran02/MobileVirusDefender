//
//  ScoreboardHelper.swift
//  MobileVirusDefender
//
//  Created by Tieran on 02/12/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import Foundation

class ScoreboardHelper
{
    private static var currentPlayerName : String?
    public static var CurrentPlayer : String = {
        return currentPlayerName ?? ""
    }()
    
    static func SetPlayerName(name : String)
    {
        currentPlayerName = name
    }
    
    static func UpdateScore(score : Int32)
    {
        if currentPlayerName == nil
        {
            return
        }
    
        var highscores = UserDefaults.standard.dictionary(forKey: "highscores")
        
        if highscores == nil
        {
            highscores = [String:Int32]()
            highscores![currentPlayerName!] = score
            UserDefaults.standard.setValue(highscores, forKey: "highscores")
        }
        else
        {
            if let currentscore = highscores![currentPlayerName!] as? Int32
            {
                if score > currentscore {
                    highscores![currentPlayerName!] = score
                }
            }
            else
            {
                highscores![currentPlayerName!] = score
            }
            
            UserDefaults.standard.setValue(highscores, forKey: "highscores")
        }
    }
    
    static func getScoresAsStrings() -> [String]
    {
        if let highscores = UserDefaults.standard.dictionary(forKey: "highscores")
        {
            return highscores.map{ "\($0): \($1)" }
        }
        return [String]()
    }
}
