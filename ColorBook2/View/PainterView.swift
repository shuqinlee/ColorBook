//
//  PainterView.swift
//  Drawer
//
//  Created by Shuqin Lee on 23/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import Foundation
import UIKit

class PainterView: UIView {
    enum DrawingState {
        case ERASER
        case PEN
    }
    enum BlendMode {
        case MIX
        case OVERLAY
    }
    var originalPainting: UIImage?

    var _content: PaintContent?
    var paintColor: UIColor
    var paintWidth: CGFloat
    var state: DrawingState = .PEN
    var blendMode: BlendMode = .MIX
    var touchMoved: Bool = false
    
    override init(frame: CGRect) {
        paintColor = .black
        paintWidth = 10.0
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        paintColor = .black
        paintWidth = 10.0
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        guard let _tmpImg = originalPainting else { return }
        _tmpImg.draw(at: .zero)
        
        switch state {
            // Sets how sample values are composited by a graphics context.
        case .ERASER:
            context.setBlendMode(.clear)
            UIColor.clear.setStroke()
        case .PEN:
            switch blendMode {
            case .OVERLAY:
                context.setBlendMode(.normal)
            case .MIX:
                context.setBlendMode(.plusDarker)
            }
            _content?.color.setStroke()
        }
        _content?.path.stroke()
        super.draw(rect)
    }
    
    func snapImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image;
        
    }
    
    func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point: CGPoint = touchPoint(touches)
        _content = PaintContent()
        _content!.color = paintColor
        _content!.path.lineWidth = paintWidth
        _content?.path.move(to: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchMoved = true
        let previousPoint2 = _content?.path.currentPoint;
        let previousPoint1 = touchPrePoint(touches)
        let currentPoint = touchPoint(touches)
        let mid1: CGPoint = midPoint(p1: previousPoint1, p2: previousPoint2!)
        _content?.path.addQuadCurve(to: mid1, controlPoint: previousPoint1)
        
        let minX: CGFloat = min(min((previousPoint2?.x)!, previousPoint1.x), currentPoint.x)
        let minY: CGFloat = min(min((previousPoint2?.y)!, previousPoint1.y), currentPoint.y)
        let maxX: CGFloat = max(max((previousPoint2?.x)!, previousPoint1.x), currentPoint.x)
        let maxY: CGFloat = max(max((previousPoint2?.y)!, previousPoint1.y), currentPoint.y)
        
        let space: CGFloat = paintWidth * 0.5 + 1;
        let drawRect: CGRect = CGRect(x: minX-space, y: minY - space, width: maxX - minX + paintWidth, height: maxY - minY + paintWidth)
        
        self.setNeedsDisplay(drawRect)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchMoved {
            return
        } else {
            touchMoved = false
        }
        let previousPoint2: CGPoint = (_content?.path.currentPoint)! // next line starting point
        let previousPoint1: CGPoint = touchPrePoint(touches) // the previous touch point
        let currentPoint: CGPoint = touchPoint(touches)
        _content?.path.addQuadCurve(to: currentPoint, controlPoint: previousPoint1)
        
        let minX: CGFloat = min(min((previousPoint2.x), previousPoint1.x), currentPoint.x)
        let minY: CGFloat = min(min((previousPoint2.y), previousPoint1.y), currentPoint.y)
        let maxX: CGFloat = max(max((previousPoint2.x), previousPoint1.x), currentPoint.x)
        let maxY: CGFloat = max(max((previousPoint2.y), previousPoint1.y), currentPoint.y)
        
        let space: CGFloat = paintWidth * 0.5 + 1;
        let drawRect: CGRect = CGRect(x: minX-space, y: minY - space, width: maxX - minX + paintWidth + 2, height: maxY - minY + paintWidth + 2)
        
        self.setNeedsDisplay(drawRect)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        originalPainting = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func touchPrePoint(_ touches: Set<UITouch>) -> CGPoint {
        var validTouch: UITouch? = nil
        for touch in touches {
            guard let view = touch.view else {return CGPoint(x: -1, y: -1) }
            if view.isEqual(self) {
                validTouch = touch
                break
            }
        }
        if let validTouch = validTouch {
            return validTouch.previousLocation(in: self)
        } else {
            return CGPoint(x: -1, y: -1)
        }
    }
    
    func touchPoint(_ touches: Set<UITouch>) -> CGPoint {
        var validTouch: UITouch? = nil
        for touch in touches {
            guard let view = touch.view else {return CGPoint(x: -1, y: -1) }
            if view.isEqual(self) {
                validTouch = touch
                break
            }
        }
        if let validTouch = validTouch {
            return validTouch.location(in: self)
        } else {
            return CGPoint(x: -1, y: -1)
        }
    }
}
