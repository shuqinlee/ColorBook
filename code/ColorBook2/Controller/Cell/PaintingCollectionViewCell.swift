//
//  PaintingCollectionViewCell.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 08/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit

protocol PaintingCollectionViewCellDelegate {
    func shareButtonDidTapped(paintingCollectionViewCell: PaintingCollectionViewCell, activityController: UIActivityViewController, deleteActivity: DeleteActivity)
}

class PaintingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverView: UIImageView!
    var painting: Painting!
    var rawPainting: RawPainting!
    var ind: Int!
    var delegate: PaintingCollectionViewCellDelegate?
    @IBOutlet weak var shareButton: UIButton!
    @IBAction func onShareButtonTapped(_ sender: UIButton) {
        guard let imageToShare = rawPainting.painting else { return }
        let deleteActivity = DeleteActivity()
        deleteActivity.ind = ind
        
        let activities = [UIActivity(), deleteActivity]
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: activities)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = sender
        }
        delegate?.shareButtonDidTapped(paintingCollectionViewCell: self, activityController: activityViewController, deleteActivity: deleteActivity)
    }
}
