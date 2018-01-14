//
//  TransparentImage.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 10/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

extension UIImage {

    func transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
    
    func removeBlackBG() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return self.transparentColor(colorMasking: colorMasking)
    }
    
    func removeWhiteBG() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return self.transparentColor(colorMasking: colorMasking)
    }
}
