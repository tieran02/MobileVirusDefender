//
//  VectorExtensions.swift
//  MobileVirusDefender
//
//  Created by Tieran on 14/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//
import SpriteKit

public extension CGVector
{
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
    
    public func distanceTo(_ vector: CGVector) -> CGFloat {
        return (self - vector).length()
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
