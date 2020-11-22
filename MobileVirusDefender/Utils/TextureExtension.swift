//
//  UIImage+pixelData.swift
//
//  Created by Bojan Percevic on 5/25/15.
//  Copyright (c) 2015 sagamore-ios. All rights reserved.
//

import SpriteKit

extension SKTexture {
    func pixelData() -> [TexturePixel] {
        let bmp = self.cgImage().dataProvider!.data
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(bmp)
        var r, g, b, a: UInt8
        var pixels: [TexturePixel] = []
        
        for row in 0..<Int(self.size().height) {
            for col in 0..<Int(self.size().width) {
                r = data.pointee
                data = data.advanced(by: 1)
                g = data.pointee
                data = data.advanced(by: 1)
                b = data.pointee
                data = data.advanced(by: 1)
                a = data.pointee
                data = data.advanced(by: 1)
                pixels.append(TexturePixel(r: r, g: g, b: b, a: a, row: row, col: col))
            }
        }
        
        return pixels
    }
}

struct TexturePixel {
    var r: Float
    var g: Float
    var b: Float
    var a: Float
    var row: Int
    var col: Int
    
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8, row: Int, col: Int) {
        self.r = Float(r)
        self.g = Float(g)
        self.b = Float(b)
        self.a = Float(a)
        self.row = row
        self.col = col
    }
    
    var color: UIColor {
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(a/255.0))
    }
    
    var description: String {
        return "RGBA(\(r), \(g), \(b), \(a))"
    }
}
