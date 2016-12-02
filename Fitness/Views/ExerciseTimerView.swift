//
//  ExerciseTimerView.swift
//  ExerciseViewController
//
//  Created by Manuel Leitold on 23.06.15.
//  Copyright (c) 2015 - 2016 mani1337. All rights reserved.
//

import UIKit

class ExerciseTimerView: UIView {
    var progress = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var maxProgress = 1.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var lineWidth = 4.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var text = "3600" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var textSize = 25.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var textColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override internal func draw(_ rect: CGRect) {
        self.drawCircle(rect)
        self.drawLabel(rect)
    }
    
    fileprivate func drawCircle(_ rect: CGRect) {
        let startAngle = CGFloat(-90.0 * M_PI / 180.0)
        let endAngle = CGFloat(((self.progress / self.maxProgress) * 360.0 - 90.0) * (M_PI / 180.0))
        let radius = CGFloat(Double(rect.width) / 2.0 - self.lineWidth)
        
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: 0.0, y: 0.0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        var ovalTransform = CGAffineTransform(translationX: rect.midX, y: rect.midY)
        ovalTransform = ovalTransform.scaledBy(x: 1, y: rect.height / rect.width)
        ovalPath.apply(ovalTransform)
        
        self.tintColor.setStroke()
        ovalPath.lineWidth = CGFloat(self.lineWidth)
        ovalPath.stroke()
    }
    
    fileprivate func drawLabel(_ rect: CGRect) {
        let textStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.center
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(self.textSize)), NSForegroundColorAttributeName: self.textColor, NSParagraphStyleAttributeName: textStyle] as [String : Any]
        
        let textTextHeight = self.text.boundingRect(with: CGSize(width: rect.width, height: CGFloat.infinity), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.clip(to: rect);
        self.text.draw(in: CGRect(x: rect.minX, y: rect.minY + (rect.height - textTextHeight) / 2, width: rect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context?.restoreGState()
    }
}
