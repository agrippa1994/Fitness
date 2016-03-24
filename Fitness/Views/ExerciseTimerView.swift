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
    
    var textColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override internal func drawRect(rect: CGRect) {
        self.drawCircle(rect)
        self.drawLabel(rect)
    }
    
    private func drawCircle(rect: CGRect) {
        let startAngle = CGFloat(-90.0 * M_PI / 180.0)
        let endAngle = CGFloat(((self.progress / self.maxProgress) * 360.0 - 90.0) * (M_PI / 180.0))
        let radius = CGFloat(Double(rect.width) / 2.0 - self.lineWidth)
        
        let ovalPath = UIBezierPath()
        ovalPath.addArcWithCenter(CGPointMake(0.0, 0.0), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        var ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(rect), CGRectGetMidY(rect))
        ovalTransform = CGAffineTransformScale(ovalTransform, 1, rect.height / rect.width)
        ovalPath.applyTransform(ovalTransform)
        
        self.tintColor.setStroke()
        ovalPath.lineWidth = CGFloat(self.lineWidth)
        ovalPath.stroke()
    }
    
    private func drawLabel(rect: CGRect) {
        let textStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        
        let textFontAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(CGFloat(self.textSize)), NSForegroundColorAttributeName: self.textColor, NSParagraphStyleAttributeName: textStyle]
        
        let textTextHeight = self.text.boundingRectWithSize(CGSizeMake(rect.width, CGFloat.infinity), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).size.height
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextClipToRect(context, rect);
        self.text.drawInRect(CGRectMake(rect.minX, rect.minY + (rect.height - textTextHeight) / 2, rect.width, textTextHeight), withAttributes: textFontAttributes)
        CGContextRestoreGState(context)
    }
}
