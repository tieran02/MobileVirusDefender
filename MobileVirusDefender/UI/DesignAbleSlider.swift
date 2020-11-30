//
//  DesignAbleSlider.swift
//  MobileVirusDefender
//
//  Created by Tieran on 30/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import UIKit

@IBDesignable
class DesignAbleSlider: UISlider {

    @IBInspectable var thumbImage: UIImage?{
        didSet{
            setThumbImage(thumbImage, for: .normal)
            setThumbImage(thumbImage, for: .highlighted)
        }
    }

}
