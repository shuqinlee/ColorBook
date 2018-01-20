//
//  PainterContent.swift
//  Drawer
//
//  Created by Shuqin Lee on 23/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//


import UIKit
class PaintContent: NSObject {
    var path: UIBezierPath
    var color: UIColor
    
    override init() {
        path = UIBezierPath()
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.lineWidth = 10
        path.flatness = 0.6
        color = UIColor.black
        super.init()
    }
    
}
