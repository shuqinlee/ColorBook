//
//  PaintingPanelViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 11/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

class PaintingPanelViewController: UIViewController {
    // MARK: - outlet property
    @IBOutlet weak var mainImageView: UIImageView!
    // MARK: - none outlet property
    var painting: Painting!
    
    // MARK: - actions
    @IBAction func onPinched(_ sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            sender.scale = 1
        }
        if sender.state == .ended {
            print("pinched eneded")
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - view brain
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageView.image = UIImage(data: painting.line!)
        
        //painting.line

    }

    // MARK: - logic brain
}