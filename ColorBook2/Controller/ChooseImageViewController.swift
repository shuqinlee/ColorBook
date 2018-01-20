//
//  ChooseImageViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 09/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
import EVGPUImage2

// todo: lazy化这里面的GPUImage2组件

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH_Float = Float(UIScreen.main.bounds.width)
let SCREEN_HEIGHT_Float = Float(UIScreen.main.bounds.height)
let SCREEN_SIZE = Size(width: SCREEN_WIDTH_Float, height: SCREEN_WIDTH_Float)


protocol ChooseImageViewControllerDelegate {
    func saveButtonDidTapped(viewController: ChooseImageViewController)
}

class ChooseImageViewController: UIViewController,
                                UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {

    var delegate: ChooseImageViewControllerDelegate?
//    var book: Book!
    var rawBook: RawBook!
//    var painting: Painting?
    var rawPainting: RawPainting?
    var chosenImage: UIImage!
    let picker = UIImagePickerController()
    var pictureInput: PictureInput? {
        didSet {
            if let actualFilter = filter as? OperationGroup {
                pictureInput! --> actualFilter --> renderView
            }
        }
    }
    var cannyFilter: CannyFilter!
    var canny: CannyEdgeDetection = CannyEdgeDetection()
    var inverter: ColorInversion = ColorInversion()
    var filter: AnyObject!
    
    var renderView: RenderView = {
        let renderView = RenderView(frame: CGRect(x: 0, y: SCREEN_HEIGHT * 0.1, width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.7))
        renderView.fillMode = .preserveAspectRatioAndFill
//        renderView.fillMode = .preserveAspectRatio
        renderView.backgroundRenderColor = .white
        
        return renderView
    }()
    // MARK: - outlets
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var mereImageView: UIImageView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    // - view controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.isContinuous = false
        
        // set image border
//        mereImageView.layer.borderColor = UIColor.black.cgColor
//        mereImageView.layer.borderWidth = 2.0
        
//        cannyFilter = CannyFilter()
//
//        view.addSubview(renderView)
        title = "Choose Image"
//        navBar.title = "Choose Image"
        
//        self.setupFilterChain()

    }
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isToolbarHidden = false
        picker.delegate = self
    }
    
    // MARK: - view brain
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    
    func setupFilterChain() {
        
        //        slider.minimumValue = cannyFilter.range?.0 ?? 0
        //        slider.maximumValue = cannyFilter.range?.1 ?? 0
        //        slider.value = cannyFilter.range?.2 ?? 0
        filter = cannyFilter.initCallback()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func onCancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIBarButtonItem) {
        // save
        if let rawPainting = rawPainting {
            

            rawBook.paintingList.append(rawPainting)
            delegate?.saveButtonDidTapped(viewController: self)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func photoLibraryTapped(_ sender: UIButton) {
        picker.allowsEditing = false // want a whole picture, not an edited version
        picker.sourceType = .photoLibrary //  set the source type to the photo library.
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        //  set the media types for all types in the photo library.
        present(picker, animated: true, completion: nil) // calls present to present the picker in a default full screen modal
    }
    
    @IBAction func onSlideValueChanged(_ sender: UISlider) {
        print("slider value: \(slider.value)")
        canny = CannyEdgeDetection()
        inverter = ColorInversion()
        canny.blurRadiusInPixels = slider.value * 10
        var filteredImage = chosenImage.filterWithOperation(canny)
        filteredImage = filteredImage.removeBlackBG()!
        filteredImage = filteredImage.filterWithOperation(inverter)
        mereImageView.image = filteredImage
        
        rawPainting?.line = filteredImage
    }
    
    @IBAction func shootPhotoTapped(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true, completion: nil)
    }
    
}

extension ChooseImageViewController {
    // MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = nil
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        chosenImage = fixOrientation(img: chosenImage)
        canny = CannyEdgeDetection()
        inverter = ColorInversion()
        var filteredImage = chosenImage.filterWithOperation(canny)
        
        filteredImage = filteredImage.removeBlackBG()!
        filteredImage = filteredImage.filterWithOperation(inverter)
        mereImageView.contentMode = .scaleAspectFill
        mereImageView.image = filteredImage
        rawPainting = RawPainting()
        rawPainting!.raw =  chosenImage
        rawPainting!.line = filteredImage
        rawPainting!.id = NSUUID().uuidString
        
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(chosenImage, self, nil, nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

