//
//  PaintingPanelViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 11/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

class PaintingPanelViewController: UIViewController,
                                    UINavigationControllerDelegate {

    // MARK: - outlet property
    @IBOutlet weak var mainImageView: UIImageView!
    
    // MARK: - none outlet property
    var painting: Painting! // rm
    var paintingInd: Int!
    var rawBook: RawBook!
    var rawPainting: RawPainting!
    
    // MARK: - actions
    @IBAction func onPinched(_ sender: UIPinchGestureRecognizer) {
        
        let scale = sender.scale
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            sender.scale = 1
        }
        if sender.state == .ended && sender.velocity < -4  {
            print("Pinched eneded, velocity: \(sender.velocity), closing")
            dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - view brain
    override func viewDidLoad() {
        super.viewDidLoad()
        rawPainting = rawBook.paintingList[paintingInd]
        mainImageView.image = rawPainting.line
        
        //painting.line

    }

    // MARK: - logic brain
}
