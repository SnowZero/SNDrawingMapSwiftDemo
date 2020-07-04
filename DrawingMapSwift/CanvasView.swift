// ---------------------------------------------------------------------------
// Copyright (c) 2017 Snow
// Mobile App Development Team
// Created by: LIU,JNU-WEI
// Created Date: 2017/01/09
// Purpose: 處理map手繪時的線條呈現,擴充Touch Method
// Implementation:
// Step1 viewDidLoad() 加入
//      canvasView.frame = mapView.frame
//      canvasView.delegate = self
//      canvasView.isUserInteractionEnabled = true
// Step2:加入
//      func touchesBegan(_ touch: UITouch) ,touchesMoved,touchesEnded 等Method
// ---------------------------------------------------------------------------

import Foundation
//import CoreGraphics
import UIKit

class CanvasView : UIImageView{
    
    var location = CGPoint(x: 0, y: 0)
    weak var delegate: ViewController?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            print("CanvasView error:touch is none")
            return
        }
        guard ((delegate?.touchesBegan(touch)) != nil) else {
            print("CanvasView error:You need to add touchesMoved or touchesMoved or touchesEnded to the CanvasView")
            return
        }
        location = touch.location(in: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            print("CanvasView error:touch is none")
            return
        }

        delegate?.touchesMoved(touch)
        let currentLocation = touch.location(in: self)
        
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("CanvasView error:context is none")
            return
        }
        
        self.image?.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.frame.size.width), height: CGFloat(self.frame.size.height)))
        
        context.setLineCap(CGLineCap.round)
        context.setLineWidth(CGFloat(3.0))
        context.setStrokeColor(UIColor.blue.withAlphaComponent(0.7).cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: CGFloat(self.location.x), y: CGFloat(self.location.y)))
        context.addLine(to: CGPoint(x: CGFloat(currentLocation.x), y: CGFloat(currentLocation.y)))
        context.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.location = currentLocation


    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            print("CanvasView error:touch is none")
            return
        }

        delegate?.touchesEnded(touch)
        let currentLocation = touch.location(in: self)

        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("CanvasView error:context is none")
            return
        }
        
        
//        self.image?.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.frame.size.width), height: CGFloat(self.frame.size.height)))
//        context.setLineCap(CGLineCap.round)
//        context.setLineWidth(CGFloat(3.0))
//        //context.setStrokeColor(UIColor.blue.withAlphaComponent(0.7).cgColor)
        context.beginPath()
        context.move(to: CGPoint(x: CGFloat(self.location.x), y: CGFloat(self.location.y)))
        context.addLine(to: CGPoint(x: CGFloat(currentLocation.x), y: CGFloat(currentLocation.y)))
        context.strokePath()
        //self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.location = currentLocation

    }
    
}






