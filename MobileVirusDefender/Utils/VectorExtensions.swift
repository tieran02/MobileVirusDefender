//
//  VectorExtensions.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//
import SpriteKit

public extension CGPoint
{
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    func lerp(min: CGPoint, max: CGPoint) -> CGPoint {
        let x = self.x.lerp(min: min.x, max: max.x)
        let y = self.y.lerp(min: min.y, max: max.y)
        return CGPoint(x: x, y: y)
    }
    
    func ilerp(min: CGPoint, max: CGPoint) -> CGPoint {
        let x = self.x.ilerp(min: min.x, max: max.x)
        let y = self.y.ilerp(min: min.y, max: max.y)
        return CGPoint(x: x, y: y)
    }
    
    func length() -> CGFloat
    {
        return sqrt(x*x + y*y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
}

public extension CGVector
{
    init(point: CGPoint) {
        self.init(dx: point.x, dy: point.y)
    }
    
    func length() -> CGFloat
    {
        return sqrt(dx*dx + dy*dy)
    }
    
    func lengthSquared() -> CGFloat
    {
        return dx*dx + dy*dy
    }

    func normalized() -> CGVector
    {
        let len = length()
        return len>0 ? self / len : CGVector.zero
    }
    
    func distanceTo(_ vector: CGVector) -> CGFloat {
        return (self - vector).length()
    }
    
    func angle() -> CGFloat
    {
        return atan2(self.dy, self.dx) - 1.5708;
    }
}

public func + (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
}

public func += (left: inout CGVector, right: CGVector) {
  left = left + right
}

public func - (left: CGVector, right: CGVector) -> CGVector {
  return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
}


public func -= (left: inout CGVector, right: CGVector) {
  left = left - right
}

public func * (vector: CGVector, scalar: CGFloat) -> CGVector {
  return CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
}

public func *= (vector: inout CGVector, scalar: CGFloat) {
  vector = vector * scalar
}

public func / (vector: CGVector, scalar: CGFloat) -> CGVector {
  return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
}

public func /= (vector: inout CGVector, scalar: CGFloat) {
  vector = vector / scalar
}

public func + (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

public func - (left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

public func * (left: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: left.x * scalar, y: left.y * scalar)
}

public func += (left: inout CGPoint, right: CGPoint) {
  left = left + right
}
