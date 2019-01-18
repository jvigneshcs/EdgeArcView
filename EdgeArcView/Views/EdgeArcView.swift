//
//  EdgeArcView.swift
//  Custom Views
//
//  Created by Vignesh J on 4/5/17.
//  Copyright © 2018 Vignesh J. All rights reserved.
//

import UIKit

public enum ArcLocation: UInt8 {
    case Top;
    case Right;
    case Bottom;
    case Left;
}

@IBDesignable public class EdgeArcView: UIView {
    
    @IBInspectable public var fillColor: UIColor = .white
    @IBInspectable public var arcLength: CGFloat = 10
    @IBInspectable public var arcFillLength: Bool = false
    @IBInspectable public var arcModeClearBlend: Bool = true
    
    #if TARGET_INTERFACE_BUILDER
    @IBInspectable public var arcLocation: UInt8 = 2 {
        didSet {
            if arcLocation > 3 {
                arcLocation = 3
            }
        }
    }
    #else
    public var arcLocation: ArcLocation = .Bottom
    #endif
    
    let π: CGFloat = CGFloat(Double.pi)

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        // Drawing code
        #if TARGET_INTERFACE_BUILDER
        let arcLocation = ArcLocation(rawValue: self.arcLocation)!
        #endif
        
        let arcLength: CGFloat = calculateArcLength(withIn: rect.size, at: arcLocation)
        if arcLength <= 0 {
            return
        }
        if arcModeClearBlend {
            let context = UIGraphicsGetCurrentContext()
            fillColor.setFill()
            context?.fill(rect)
        }
        
        let path = arcPath(in: rect, of: arcLength, at: arcLocation)
        if arcModeClearBlend {
            path.stroke(with: .clear, alpha: 1)
        } else {
            fillColor.setStroke()
            path.stroke()
        }
    }

    private func radians(_ degrees: CGFloat) -> CGFloat {
        return degrees * π / 180
    }
    
    private func calculateArcLength(withIn size: CGSize, at location: ArcLocation) -> CGFloat {
        let arcLength: CGFloat
        switch location {
        case .Top, .Bottom:
            let length = arcFillLength ? size.height : self.arcLength
            arcLength = length > size.width / 2 ? size.width / 2 : length
        case .Left, .Right:
            let length = arcFillLength ? size.width : self.arcLength
            arcLength = length >= size.height / 2 ? size.height / 2 : length
        }
        return arcLength
    }
    
    private func arcPath(in rect: CGRect, of length: CGFloat, at location: ArcLocation) -> UIBezierPath {
        let arcPath: UIBezierPath
        switch location {
        case .Top:
            arcPath = arcPathTop(in: rect, of: length)
        case .Right:
            arcPath = arcPathRight(in: rect, of: length)
        case .Bottom:
            arcPath = arcPathBottom(in: rect, of: length)
        case .Left:
            arcPath = arcPathLeft(in: rect, of: length)
        }
        return arcPath
    }
    
    private func arcPathTop(in rect: CGRect, of length: CGFloat) -> UIBezierPath {
        let arcRect = CGRect(x: 0, y: 0, width: rect.width, height: length)
        let arcRadius = (length / 2) + (pow(arcRect.width, 2) / (8 * length))
        let arcCenter = CGPoint(x: arcRect.width / 2, y: length - arcRadius)
        
        let angle = acos(arcRect.width / (2 * arcRadius))
        let startAngle = angle
        let endAngle = radians(180) - angle
        let arcPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.lineWidth = arcRadius
        return arcPath
    }
    
    private func arcPathBottom(in rect: CGRect, of length: CGFloat) -> UIBezierPath {
        let arcRect = CGRect(x: 0, y: rect.height - length, width: rect.width, height: length)
        let arcRadius = (length / 2) + (pow(arcRect.width, 2) / (8 * length))
        let arcCenter = CGPoint(x: arcRect.width / 2, y: arcRect.origin.y + arcRadius)
        
        let angle = acos(arcRect.width / (2 * arcRadius))
        let startAngle = radians(180) + angle
        let endAngle = radians(360) - angle
        let arcPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.lineWidth = arcRadius
        return arcPath
    }
    
    private func arcPathLeft(in rect: CGRect, of length: CGFloat) -> UIBezierPath {
        let arcRect = CGRect(x: 0, y: 0, width: length, height: rect.height)
        let arcRadius = (length / 2) + (pow(arcRect.height, 2) / (8 * length))
        let arcCenter = CGPoint(x: length - arcRadius, y: arcRect.height / 2)
        
        let angle = acos(arcRect.height / (2 * arcRadius))
        let startAngle = radians(270) + angle
        let endAngle = radians(90) - angle
        let arcPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.lineWidth = arcRadius
        return arcPath
    }
    
    private func arcPathRight(in rect: CGRect, of length: CGFloat) -> UIBezierPath {
        let arcRect = CGRect(x: rect.width - length, y: 0, width: length, height: rect.height)
        let arcRadius = (length / 2) + (pow(arcRect.height, 2) / (8 * length))
        let arcCenter = CGPoint(x: arcRect.origin.x + arcRadius, y: arcRect.height / 2)
        
        let angle = acos(arcRect.height / (2 * arcRadius))
        let startAngle = radians(90) + angle
        let endAngle = radians(270) - angle
        let arcPath = UIBezierPath(arcCenter: arcCenter, radius: arcRadius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        arcPath.lineWidth = arcRadius
        return arcPath
    }
}
