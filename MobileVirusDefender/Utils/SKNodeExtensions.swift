//
//  SKNodeExtensions.swift
//  MobileVirusDefender
//
//  Created by Tieran on 24/11/2020.
//  Copyright © 2020 Tieran. All rights reserved.
//

import SpriteKit

extension SKNode {
    var positionInScene:CGPoint? {
        if let scene = scene, let parent = parent {
            return parent.convert(position, to:scene)
        } else {
            return nil
        }
    }
}

extension SKPhysicsBody
{
    override open func copy() -> Any {
        guard let body = super.copy() as? SKPhysicsBody else {fatalError("SKPhysicsBody.copy() failed")}
        body.affectedByGravity = affectedByGravity
        body.allowsRotation = allowsRotation
        body.isDynamic = isDynamic
        body.mass = mass
        body.density = density
        body.friction = friction
        body.restitution = restitution
        body.linearDamping = linearDamping
        body.angularDamping = angularDamping

        return body
    }
}
