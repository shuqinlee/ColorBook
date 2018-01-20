//
//  PaintingPanelViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 11/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
import EFColorPicker
import SwiftOverlays

protocol PaintingPanelDelegate {
    func didClosed(paintingPanelViewController: PaintingPanelViewController)
    func didDeleted(paintingPanelViewController: PaintingPanelViewController, index: Int)
}

class PaintingPanelViewController: UIViewController,
                                    UINavigationControllerDelegate,
                                    UIPopoverPresentationControllerDelegate {

    // MARK: - outlet property
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var eraser: UIButton!
    @IBOutlet weak var pen: UIButton!
    @IBOutlet weak var smallStroke: UIButton!
    @IBOutlet weak var midStroke: UIButton!
    @IBOutlet weak var bigStroke: UIButton!
    @IBOutlet weak var drawingContainer: UIView!
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBOutlet var rotationGesture: UIRotationGestureRecognizer!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet weak var blendModeButton: UIButton!
    
    @IBOutlet weak var colorPicker: UIButton!
    
    // MARK: - none outlet property
    var painting: Painting! // rm
    var paintingInd: Int!
    var rawBook: RawBook!
    var rawPainting: RawPainting!
    var panel: PainterView!
    var delegate: PaintingPanelDelegate?
    
    // MARK: - actions
    // todo: enable user to custom width?
    @IBAction func smallStrokeTapped(_ sender: UIButton) {
        
        if !sender.isSelected {
            sender.isSelected = true
            panel.paintWidth = 5
            smallStroke.backgroundImage(for: .selected)
            smallStroke.imageView?.image = #imageLiteral(resourceName: "circle-selected.png") // selected
            midStroke.imageView?.image = #imageLiteral(resourceName: "circle-unselected.png") // unselected
            bigStroke.imageView?.image = #imageLiteral(resourceName: "circle-unselected.png")
            
            midStroke.isSelected = false
            bigStroke.isSelected = false
        }
        
    }
    
    @IBAction func midStrokeTapped(_ sender: UIButton) {
        if !sender.isSelected {
            panel.paintWidth = 10
            sender.isSelected = true
            smallStroke.isSelected = false
            bigStroke.isSelected = false
        }
    }
    
    @IBAction func bigStrokeTapped(_ sender: UIButton) {
        if !sender.isSelected {
            panel.paintWidth = 15
            sender.isSelected = true
            smallStroke.isSelected = false
            midStroke.isSelected = false
        }
    }
    
    @IBAction func penButtonTapped(_ sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            eraser.isSelected = false
            panel.state = .PEN
        }
    }
    
    @IBAction func eraserButtonTapped(_ sender: UIButton) {
        if !sender.isSelected { // was not selected
            sender.isSelected = true
            pen.isSelected = false
            panel.state = .ERASER
        }
    }
    
    @IBAction func onPinched(_ sender: UIPinchGestureRecognizer) {
        print("pinched")
        let scale = sender.scale
        if let view = sender.view {
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            sender.scale = 1
        }
        if sender.state == .ended && sender.velocity < -4  {
            print("Pinched eneded, velocity: \(sender.velocity), closing")
            // save the painting
            let image = panel.snapImage()
            rawBook.paintingList[paintingInd].painting = image
            delegate?.didClosed(paintingPanelViewController: self)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onRotated(_ sender: UIRotationGestureRecognizer) {
        print("rotated")
        if let view = sender.view {
            view.transform = view.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    
    @IBAction func onPanned(_ sender: UIPanGestureRecognizer) {
        
        print("panned and drag")
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            view.center = translation + view.center
        }
        sender.setTranslation(CGPoint.zero, in: self.view)
        
    }
    
    @IBAction func onLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: sender.view)
            let view: PaintingPanelView = (sender.view as? PaintingPanelView)!
            let color = view.getPixelColorAt(point: location)
            colorPicker.backgroundColor = color
            panel.paintColor = color
        }
        
        if let view = self.view as? PaintingPanelView {
            print(view.color ?? 0)
            colorPicker.backgroundColor = view.color
        }
    }
    
    @IBAction func onColorPickerClicked(_ sender: UIButton) {
        let colorSelectionController = EFColorSelectionViewController()
        
        let navCtrl = UINavigationController(rootViewController: colorSelectionController)

        navCtrl.navigationBar.backgroundColor = UIColor(hex: "FFDB0C")
        navCtrl.navigationBar.isTranslucent = false
        navCtrl.modalPresentationStyle = .popover
        navCtrl.popoverPresentationController?.delegate = self
        navCtrl.popoverPresentationController?.sourceView = sender
        navCtrl.popoverPresentationController?.sourceRect = sender.bounds
        navCtrl.preferredContentSize = colorSelectionController.view.systemLayoutSizeFitting(
            UILayoutFittingCompressedSize
        )
        
        colorSelectionController.isColorTextFieldHidden = false
        colorSelectionController.delegate = self
//        colorSelectionController.color = self.view.backgroundColor ?? UIColor.white
        colorSelectionController.color = colorPicker.backgroundColor!
        let doneBtn: UIBarButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Done", comment: ""),
            style: UIBarButtonItemStyle.done,
            target: self,
            action: #selector(ef_dismissViewController(sender:))
        )
        colorSelectionController.navigationItem.rightBarButtonItem = doneBtn
        self.present(navCtrl, animated: true, completion: nil)
    }
    
    @IBAction func onBlendButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            // mix
            panel.blendMode = .MIX
        } else {
            panel.blendMode = .OVERLAY
        }
    }
    
    @IBAction func onShareButtonTapped(_ sender: UIBarButtonItem) {
        let image = panel.snapImage()
        guard let imageToShare = image else { return }
        rawBook.paintingList[paintingInd].painting = imageToShare
        let activities = [UIActivity()]
        
//        ac.
        let activityViewController = UIActivityViewController(activityItems: [imageToShare], applicationActivities: activities)
        activityViewController.popoverPresentationController?.sourceView = self.view
//        activityViewController.modalPresentationStyle = .
        activityViewController.completionHandler = { activityType, error in
            print("\(activityType)")
            print("\(error.description)")
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onDeleteButtonTapped(_ sender: UIBarButtonItem) {
//        rawBook.paintingList
        let confirmDeleteAction = UIAlertAction(title: "确认删除", style: .destructive, handler: {
            action in
            self.delegate?.didDeleted(paintingPanelViewController: self, index: self.paintingInd)
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(confirmDeleteAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - view brain
    override func viewDidLoad() {
        super.viewDidLoad()
        // load painting tools
        panel = PainterView(frame: CGRect(x: 0, y: 0, width: drawingContainer.bounds.size.width, height: drawingContainer.bounds.size.height))
        drawingContainer.addSubview(panel)
        
        // load original data
        rawPainting = rawBook.paintingList[paintingInd]
        
        
        mainImageView.image = rawPainting.line
        if var painting = rawPainting.painting {
            // for unknown reason, the size of painting is changing??
            painting = resizeImage(image: painting, targetSize: CGSize(width: drawingContainer.bounds.width, height: drawingContainer.bounds.height))
            panel.originalPainting = painting
            panel.setNeedsDisplay(drawingContainer.bounds)
        }

        // component set up
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        panGesture.delegate = self
        longPressGesture.delegate = self
        
        let strokes = [smallStroke, midStroke, bigStroke]
        for stroke in strokes {
            stroke?.setBackgroundImage(#imageLiteral(resourceName: "circle-unselected.png"), for: .normal)
            stroke?.setBackgroundImage(#imageLiteral(resourceName: "circle-selected.png"), for: .selected)
        }
        
        pen.setBackgroundImage(#imageLiteral(resourceName: "pencil-unselected.png"), for: .normal)
        pen.setBackgroundImage(#imageLiteral(resourceName: "pencil-selected.png"), for: .selected)
        eraser.setBackgroundImage(#imageLiteral(resourceName: "eraser-unselected.png"), for: .normal)
        eraser.setBackgroundImage(#imageLiteral(resourceName: "eraser-selected.png"), for: .selected)
        blendModeButton.setBackgroundImage(#imageLiteral(resourceName: "mixed.png"), for: .normal)
        blendModeButton.setBackgroundImage(#imageLiteral(resourceName: "overlay.png"), for: .selected)

    }
    
    @objc func ef_dismissViewController(sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            [weak self] in
            if let _ = self {
                // TODO: You can do something here when EFColorPicker close.
                print("EFColorPicker closed.")
            }
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    // MARK: - logic brain
}

extension PaintingPanelViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension PaintingPanelViewController: EFColorSelectionViewControllerDelegate {
    func colorViewController(colorViewCntroller: EFColorSelectionViewController, didChangeColor color: UIColor) {
        colorPicker.backgroundColor = color
        panel.paintColor = color
    }
}
