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

class PaintingCollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var book: Book!
    var rawBook: RawBook!
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        if rawBook.paintingList.count == 0 && rawBook.book != nil {
            book = rawBook.book
            rawBook.paintingList = Realm2Raw.paintingList(paintingList: book.paintingList)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "chooseImageSegue" {
//            segue.destination.title = "Choose Image"
            let chooseImageViewController = segue.destination as! ChooseImageViewController
            
            chooseImageViewController.rawBook = rawBook
            chooseImageViewController.delegate = self
        } else if identifier == "showPaintingPanelSegue" {
            let paintingPanelVC = segue.destination as! PaintingPanelViewController
//            paintingPanelVC
            if let sender = sender as? PaintingCollectionViewCell {
                paintingPanelVC.painting = sender.painting // rm
                
                paintingPanelVC.paintingInd = sender.ind
                paintingPanelVC.rawBook = rawBook
            }
        }
    }

   
}

extension PaintingCollectionViewController: ChooseImageViewControllerDelegate {
    func saveButtonDidTapped(viewController: ChooseImageViewController) {
        print("New painting account: \(rawBook.paintingList.count)")
        collectionView.reloadData()
    }
}

extension PaintingCollectionViewController:
                        UICollectionViewDataSource,
                        UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (rawBook.paintingList.count)  + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            let painting = rawBook.paintingList[ind-1]
            var cover: UIImage!
            if let pp = painting.painting {
                cover = pp
            } else if let pp = painting.raw {
                cover = pp
            }
            
            cell.coverView.image = cover
            cell.rawPainting = rawBook.paintingList[ind-1]
            cell.painting = rawBook.paintingList[ind-1].pp
            cell.ind = ind - 1
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

