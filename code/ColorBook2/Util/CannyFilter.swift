//
//  CannyFilter.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 09/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
import EVGPUImage2

typealias InitCallback = () -> (AnyObject)
typealias ValueChangedCallback = (AnyObject, Float) -> ()
typealias CustomCallback = (PictureInput, AnyObject, RenderView) -> ()

class CannyFilter: NSObject {
    
    var range: (Float, Float, Float)?
    var initCallback: InitCallback!
    var valueChangedCallback: ValueChangedCallback?
    var customCallback: CustomCallback?
    
    init(range: (Float, Float, Float)? = (0.0, 1.0, 0.0)) {
        self.initCallback = {
            let canny = CannyEdgeDetection()
//            canny.blurRadiusInPixels = 0
//            canny.lowerThreshold = 0
//            canny.upperThreshold = 10
            return canny
            
        }
        self.valueChangedCallback = { (filter, value) in
//            let canny = (filter as! CannyEdgeDetection)
//            canny.blurRadiusInPixels = value * 10
//            canny.lowerThreshold = 0
//            canny.upperThreshold = 10
            (filter as! CannyEdgeDetection).blurRadiusInPixels = value * 10
        }
        
    }

}
