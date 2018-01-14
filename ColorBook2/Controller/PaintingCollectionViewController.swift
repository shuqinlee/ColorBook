//
//  PaintingCollectionViewController.swift
//  ColorBook2
//
//  Created by Shuqin Lee on 06/01/2018.
//  Copyright © 2018 Shuqin Lee. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "PaintingCell"
private let newPaintingIdentifier = "NewPaintingCell"
class PaintingCollectionViewController: UICollectionViewController {

    var book: Book!
//    var paintingList: Results<Painting>?
    var paintingList: List<Painting>?
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paintingList = book.paintingList
//        let realm = try! Realm(configuration: Config.REALM_CONFIG)
//        let predicate = NSPredicate(format: "book.id = %@", book.id!)
//        self.paintingList = realm.objects(Painting.self).filter(predicate)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "chooseImageSegue" {
//            segue.destination.title = "Choose Image"
            let chooseImageViewController = segue.destination as! ChooseImageViewController
            chooseImageViewController.book = book
            chooseImageViewController.delegate = self
        } else if identifier == "showPaintingPanelSegue" {
            let paintingPanelVC = segue.destination as! PaintingPanelViewController
//            paintingPanelVC
            if let sender = sender as? PaintingCollectionViewCell {
                paintingPanelVC.painting = sender.painting
            }
        }
    }

   
}

extension PaintingCollectionViewController: ChooseImageViewControllerDelegate {
    func saveButtonDidTapped(viewController: ChooseImageViewController) {
        print("New painting account: \(paintingList?.count ?? 0)")
        collectionView?.reloadData()
    }
}

extension PaintingCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (paintingList?.count ?? 0)  + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ind: Int = (indexPath as NSIndexPath).row
        
        if ind == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newPaintingIdentifier, for: indexPath) as! NewPaintingViewCell
            
            let cover = UIImage(named: "newImgView.png", in: Bundle.main, compatibleWith: nil)
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 2.0
            cell.coverView.image = cover
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PaintingCollectionViewCell
            let painting = paintingList![ind-1]
            var cover: UIImage!
            if let pp = painting.painting {
                cover = UIImage(data: pp)
            } else if let pp = painting.raw {
                cover = UIImage(data: pp)
            }
//            let cover = UIImage(data: paintingList![ind-1].painting!)
            
            cell.coverView.image = cover // ImageProcess.addBlurFilter(image: cover!)
            cell.painting = paintingList![ind-1]
            return cell
        }
    }
    
}

extension PaintingCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 1.4)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

