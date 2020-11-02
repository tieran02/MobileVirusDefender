//
//  JoystickUI.swift
//  MobileVirusDefender
//
//  Created by Tieran on 02/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit

class JoystickUI: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var OuterPad: UIImageView!
    @IBOutlet weak var CenterPad: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed("JoystickUI", owner: self, options: nil)

        addSubview(contentView)
        contentView.frame = self.bounds
    }
}
