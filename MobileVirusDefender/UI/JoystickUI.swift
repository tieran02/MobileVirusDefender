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
    
    public var IsTracking : Bool = false
    
    private var _direction : CGVector = CGVector(dx: 0, dy: 0)
    var Direction : CGVector {
        get{
            return _direction
        }
    }
    
    var origin : CGPoint = CGPoint()
    var currentPos : CGPoint = CGPoint()
    
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
        
        CenterPad.center.x = contentView.frame.midX
        CenterPad.center.y = contentView.frame.midY
        //OuterPad.center.x = contentView.frame.midX
        //OuterPad.center.y = contentView.frame.midY
        
        CenterPad.frame = CGRect(x: contentView.center.x,
                                 y: contentView.center.y,
                                 width: CenterPad.frame.width,
                                 height: CenterPad.frame.height)
        
        origin = CenterPad.frame.origin
    }
    

    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        /*
         // 1
         let translation = gesture.translation(in: CenterPad)

         // 2
         guard let gestureView = gesture.view else {
         return
         }

         gestureView.center = CGPoint(
         x: gestureView.center.x + translation.x,
         y: gestureView.center.y + translation.y
         )

         let localPosition : CGP gesture.location(in: CenterPad)
         
         // 3
         gesture.setTranslation(.zero, in: CenterPad)
         */
        // 1

        guard let gestureView = gesture.view else {
        return
        }
        
        var locationOfBeganTap: CGPoint = CGPoint()

        if gesture.state == UIGestureRecognizer.State.began
        {
            currentPos = CenterPad.center
        }
        else if gesture.state == UIGestureRecognizer.State.ended
        {
            gestureView.center = origin
            currentPos = CGPoint(x: origin.x - OuterPad.frame.width/2, y: origin.y - OuterPad.frame.height/2)
            return
        }

        let translation = gesture.translation(in: CenterPad)
        currentPos = CGPoint(x: currentPos.x + translation.x, y: currentPos.y + translation.y)


        let radius = OuterPad.frame.width/2
        let dist : CGFloat = distance(currentPos, origin)

        
        gestureView.center = CGPoint(
        x: gestureView.center.x + translation.x,
        y: gestureView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: CenterPad)

        _direction = CGVector(dx: currentPos.x / radius, dy: currentPos.y / radius)

        print("distance \(dist)  currentPos:\(currentPos)  origin:\(origin)  dir:\(_direction)")

        //gestureView.center = tempPoint
        
    }
    
    
    func minus(_ a:CGPoint, _ b:CGPoint ) -> CGPoint
    {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGPoint(x: xDist, y: yDist)
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}
