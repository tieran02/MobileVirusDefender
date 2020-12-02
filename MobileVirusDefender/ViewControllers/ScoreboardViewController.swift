//
//  ScoreboardViewController.swift
//  MobileVirusDefender
//
//  Created by Tieran on 02/12/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import Foundation
import UIKit

class ScoreboardViewController : UIViewController,  UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var ScoreboardTableView: UITableView!
    @IBOutlet weak var CurrentPlayerLabel: UILabel!
    
    // Data model: These strings will be the data for the table view cells
    let scores: [String] = ScoreboardHelper.getScoresAsStrings()
        
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentPlayerLabel.text = "Player: \(ScoreboardHelper.CurrentPlayer)"
        // Register the table view cell class and its reuse id
        self.ScoreboardTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        ScoreboardTableView.delegate = self
        ScoreboardTableView.dataSource = self
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scores.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = ScoreboardTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        
        // set the text from the data model
        cell.textLabel?.text = self.scores[indexPath.row]
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
