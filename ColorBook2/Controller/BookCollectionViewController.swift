//
//  BookCollectionViewController.swift
//  ColorBook
//
//  Created by Shuqin Lee on 11/12/2017.
//  Copyright © 2017 Shuqin Lee. All rights reserved.
//

import UIKit
import RealmSwift

class BookCollectionViewController: UICollectionViewController {
    
    fileprivate let reuseIdentifier = "BookCell"
    fileprivate let newBookIdentifier = "NewBookCell"
    static var bookList:[RawBook]?// = LocalFileLoader.loadBookList()
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        title = "Books"
//        let realm = try! Realm(configuration: Config.REALM_CONFIG)
//        self.bookList = realm.objects(Book.self)
        BookCollectionViewController.bookList = RealmUtil.fetchBookList()
        if BookCollectionViewController.bookList?.count == 0 {
            bookList = LocalFileLoader.loadBookList()
        }
        
        
        /**
        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm(configuration: Config.REALM_CONFIG)
            
            self.bookList = realm.objects(Book.self)
            if self.bookList?.count == 0 {
//                realm.beginWrite()
                LocalFileLoader.loadBookList()
                
            }
//            realm.writeCopy(toFile: <#T##URL#>)
        }*/
        /**
        // Query and update from any thread
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm(configuration: config) // should use the same configuration
                let theDog = realm.objects(Dog.self).filter("age = 1").first
                print("Age: \(String(describing: theDog?.age))")
                try! realm.write {
                    theDog!.age = 3
                }
            }
        }
 */
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPaintingControllerSegue" {
            let paintingController = segue.destination as! PaintingCollectionViewController
            
            if let sender = sender as? BookCollectionViewCell {
                paintingController.book = sender.book
                paintingController.title = sender.bookName.text
            }
        }
    }
}

extension BookCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (BookCollectionViewController.bookList?.count ?? 0) + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ind: Int = (indexPath as NSIndexPath).row
        
        if ind == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newBookIdentifier, for: indexPath) as! NewBookViewCell
            
            let cover = UIImage(named: "newImgView.png", in: Bundle.main, compatibleWith: nil)
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 2.0
            cell.coverView.image = cover
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
            
            let name  = BookCollectionViewController.bookList![ind-1].name
            let cover = UIImage(data: BookCollectionViewController.bookList![ind-1].cover!)
            cell.book = BookCollectionViewController.bookList![ind-1]
            cell.bookName.text = name
            cell.coverView.image = cover // ImageProcess.addBlurFilter(image: cover!)
            return cell
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let paintingCollectionViewController = PaintingCollectionViewController(collectionViewLayout: UICollectionViewLayout())
//        paintingCollectionViewController.book = bookList![indexPath.row]
//        paintingCollectionViewController.title = bookList![indexPath.row].name
//        navigationController?.pushViewController(paintingCollectionViewController, animated: true)
//    }
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
