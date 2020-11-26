//
//  FloatExtensions.swift
//  MobileVirusDefender
//
//  Created by Tieran on 26/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit
extension CGFloat {
    
    /// Linear interpolation
    public func lerp(min: CGFloat, max: CGFloat) -> CGFloat {
        return min + (self * (max - min))
    }
    
    /// Inverse linear interpolation
    public func ilerp(min: CGFloat, max: CGFloat) -> CGFloat {
        return (self - min) / (max - min)
    }
    
}
