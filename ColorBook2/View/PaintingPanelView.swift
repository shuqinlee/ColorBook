//
//  PaintingPanelView.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 18/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

class PaintingPanelView: UIView {
    var color: UIColor?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: self) {
            color = self.getPixelColorAt(point: point)
            print(color!)
        }
    }

}

