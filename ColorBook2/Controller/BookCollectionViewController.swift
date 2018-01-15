//
//  BookCollectionViewController.swift
//  ColorBook
//
//  Created by Shuqin Lee on 11/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import UIKit
import RealmSwift
import SlideMenuControllerSwift

typealias BCVC = BookCollectionViewController
//class BookCollectionViewController: UICollectionViewController {
class BookCollectionViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var viewContriant: NSLayoutConstraint!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var sideTableView: UITableView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - non outlet property
    static var bookList = [RawBook]()// = LocalFileLoader.loadBookList()
    fileprivate let reuseIdentifier = "BookCell"
    fileprivate let newBookIdentifier = "NewBookCell"
    
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2

    
    
    // MARK: - methods
    override func viewDidLoad() {
        title = "Books"
        collectionView.delegate = self
        
        BCVC.bookList = Realm2Raw.bookList(bookList: RealmUtil.fetchBookList())
        if BCVC.bookList.count == 0 {
            BCVC.bookList = LocalFileLoader.loadBookList()
        }
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.5
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        self.viewContriant.constant = -190
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPaintingControllerSegue" {
            let paintingController = segue.destination as! PaintingCollectionViewController
            
            if let sender = sender as? BookCollectionViewCell {
                paintingController.book = sender.book
                paintingController.rawBook = sender.rawBook
                paintingController.title = sender.bookName.text
            }
        } else if segue.identifier == "newBookSegue" {
            let newBookVC = segue.destination as! NewBookViewController
            newBookVC.delegate = self
        }
    }

    class func saveBooks() {
        var realmBookList = [Book]()
        for book in bookList {
            realmBookList.append(Raw2Realm.book(rawBook: book))
        }
        RealmUtil.saveBookList(bookList: realmBookList)
    }
    @IBAction func panGesturePerformed(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view).x
            if translation > 0 { // swipe right
                
                if viewContriant.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewContriant.constant += translation
                        self.view.layoutIfNeeded()
                        })
                }
            } else { // swipe left
                if viewContriant.constant > -190 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.viewContriant.constant += translation
                        self.view.layoutIfNeeded()
                    })
                }
            }
        } else if sender.state == .ended {
            
            if self.viewContriant.constant < -100 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewContriant.constant = -190
                    self.view.layoutIfNeeded()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewContriant.constant = 0
                    self.view.layoutIfNeeded()
                })
            }
            
        }
    }
}

// MARK: - extensions
extension BookCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BCVC.bookList.count  + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ind: Int = (indexPath as NSIndexPath).row
        
        if ind == 0 {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: newBookIdentifier, for: indexPath) as! NewBookViewCell
            
            let cover = UIImage(named: "newImgView.png", in: Bundle.main, compatibleWith: nil)
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 2.0
            cell.coverView.image = cover
            return cell
        } else {
            let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
            
            let name  = BCVC.bookList[ind-1].name
            let cover = BCVC.bookList[ind-1].cover!
            
            cell.rawBook = BCVC.bookList[ind-1]
            cell.bookName.text = name
            cell.coverView.image = cover // ImageProcess.addBlurFilter(image: cover!)
            return cell
        }
    }
}

extension BookCollectionViewController : UICollectionViewDelegateFlowLayout {
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

extension BookCollectionViewController: NewBookViewControllerDelegate {
    func newBookViewController(newBookViewController: NewBookViewController, rawBook: RawBook) {
        BCVC.bookList.append(rawBook)
        self.collectionView.reloadData()
    }
}

//extension BookCollectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//    
//}

