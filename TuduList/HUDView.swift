//
//  HUDView.swift
//  TuduList
//
//  Created by Bruno Paulino on 10/7/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

import UIKit

class HUDView: UIView {
    
    var text:String?
    
    
    class func hudInView(view:UIView, animated:Bool) -> HUDView{
        let hudView:HUDView = HUDView()
        hudView.opaque = false
        
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        
        hudView.showAnimated(animated)
        
        return hudView
    }
    
    func showAnimated(animated:Bool) -> Void{
        
        if animated{
            self.alpha = 0.0
            self.transform = CGAffineTransformMakeScale(1.3, 1.3)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 1.0
                self.transform = CGAffineTransformIdentity
            })
        }
        
    }
    
    override func drawRect(rect: CGRect)
    {
        let boxWidth:CGFloat = 96.0
        let boxHeight:CGFloat = 96.0
        let boxRect = CGRectMake(self.bounds.size.width - round(boxWidth / 2.0),
            self.bounds.size.width - round(boxHeight / 2.0), boxWidth, boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10.0)
        
        let color = UIColor(white: 0.3, alpha: 0.8)
        color.setFill()
        roundedRect.fill()
        
        let image = UIImage(named: "Checkmark.png")
        
        let imagePoint = CGPointMake(self.center.x - round(image.size.width/2.0), self.center.x - round(image.size.width/2.0))
        
        image.drawAtPoint(imagePoint)
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(16.0),
            NSForegroundColorAttributeName: UIColor.whiteColor()
        ]
        
        let textSize = (self.text! as NSString).sizeWithAttributes(attributes)
        
        let textPoint = CGPointMake(self.center.x - round(textSize.width / 2.0),
            self.center.y - round(textSize.height / 2.0) + boxHeight / 4.0)
        
        (self.text! as NSString).drawAtPoint(textPoint, withAttributes: attributes)
    }

}


































