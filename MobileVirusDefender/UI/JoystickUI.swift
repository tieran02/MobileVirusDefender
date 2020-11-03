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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(!IsTracking)
        {
            for touch in touches {
                let touchPoint : CGPoint = touch.location(in: self)

                if(CenterPad.frame.contains(touchPoint))
                {
                    IsTracking = true
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if IsTracking
        {
            for touch in touches
            {
                let touchPoint : CGPoint = touch.location(in: self)
                
                
                let radius = OuterPad.frame.width/2
                let dist : CGFloat = distance(touchPoint, origin)
                
                if(dist <= radius)
                {
                    CenterPad.center = touchPoint
                }
                else
                {
                    //let originToObject = CGPoint(x: touchPoint.x * (radius/dist),y: touchPoint.y * (radius/dist))
                    //CenterPad.center = minus(originToObject, origin)
                    let boundedPos = CGPoint(x: origin.x + (touchPoint.x - origin.x) / dist * radius,
                                             y: origin.y + (touchPoint.y - origin.y) / dist * radius)
                    CenterPad.center = boundedPos
                }
                
                _direction = CGVector(dx: (CenterPad.center.x - origin.x) / radius, dy: (origin.y - CenterPad.center.y) / radius)
                print(Direction)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        IsTracking = false
        CenterPad.center = origin
        _direction = CGVector(dx: 0, dy: 0)
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
}
